//
//  ViewController.m
//  CoreDataVsSqliteView
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "Benchmark.h"
#import "User.h"
#import "FMResultSet.h"

#define APP_DELEGATE    ((AppDelegate *) [[UIApplication sharedApplication] delegate])

#define INSERT_RUNS 1000
#define QUERY_ALL_RUNS 1000
#define QUERY_ID_RUNS 1000
#define USER_COLUMN_COUNT 3

@implementation ViewController

- (void)viewDidLoad
{
    [self runBenchmarks];
    [super viewDidLoad];
}

- (void) runBenchmarks {
    [self insertSqlLite];
    [self insertCoreData];
    
    [self queryAllSqliteLite];
    [self queryAllCoreData];
    
    [self queryIdSqlite];
    [self queryIdCoreData];
}

// sqlite
- (void) insertSqlLite {
    FMDatabase *connection = [APP_DELEGATE sqliteConnection];
    
    NSString *benchmarkName = [NSString stringWithFormat: @"inserting %i records with sqlite", INSERT_RUNS];
    
    [Benchmark benchmark: benchmarkName withBlock: ^{
        for (int i = 1; i <= INSERT_RUNS; i++) {
//            NSLog(@"sqlite: inserting id: %i", i);
            NSString *sql = @"insert into users (firstName, lastName) values (?, ?)";
            [connection executeUpdate: sql, @"Scott", @"Taylor"];
            
            if ([connection hadError]) {
                NSString *msg = [connection lastErrorMessage];
                
                if (msg && msg != nil) {
                    NSLog(@"error!: %@", msg);
                }
            } else {
//                NSLog(@"inserted row with id: %lld", [connection lastInsertRowId]);
            }
        }
    }];
}

- (void) deleteAllCoreData {
    [APP_DELEGATE deleteAllCoreData];
}


- (void) queryAllSqliteLite {
    FMDatabase *connection = [APP_DELEGATE sqliteConnection];
    
    NSString *benchmarkName = [NSString stringWithFormat: @"selecting all records with sqlite, users table", INSERT_RUNS];
    
    [Benchmark benchmark: benchmarkName withBlock: ^{
        for (int i = 0; i < QUERY_ALL_RUNS; i++) {
            NSMutableArray *fetchResults = [NSMutableArray array];
            
            NSString *sql = @"select * from users";
            FMResultSet *results = [connection executeQuery: sql];

            if ([connection hadError]) {
                NSString *msg = [connection lastErrorMessage];
                
                if (msg && msg != nil) {
                    NSLog(@"error!: %@", msg);
                }
            }
            
            while ([results next]) {
                NSMutableArray *values = [NSMutableArray arrayWithCapacity: USER_COLUMN_COUNT];
                
                for (int columnCount = 0; columnCount < USER_COLUMN_COUNT; columnCount++) {
                    if (columnCount == 0) { // id
                        [values addObject: [NSNumber numberWithLongLong: [results longLongIntForColumnIndex: columnCount]]];
                    } else { // string
                        [values addObject: [results stringForColumnIndex: columnCount]];
                    }
                }
                
                [fetchResults addObject: values];
            }
            
            if (i == 0) {
                NSLog(@"fetchResults count: %i", [fetchResults count]);    
            }

        }
        
    }];

}

- (void) queryIdSqlite {
    FMDatabase *connection = [APP_DELEGATE sqliteConnection];
    
    NSString *benchmarkName = [NSString stringWithFormat: @"selecting id records with sqlite, users table", INSERT_RUNS];
    
    [Benchmark benchmark: benchmarkName withBlock: ^{
        for (int i = 1; i <= QUERY_ID_RUNS; i++) {
//            NSLog(@"finding with id = %i", i);
            NSMutableArray *fetchResults = [NSMutableArray array];
            
            NSString *sql = @"select * from users where id = ?";
            FMResultSet *results = [connection executeQuery: sql, [NSNumber numberWithInteger: i]];
            
            if ([connection hadError]) {            
                NSString *msg = [connection lastErrorMessage];

                if (msg && msg != nil) {
                    NSLog(@"error!: %@", msg);
                }
            }
            
            while ([results next]) {
                NSMutableArray *values = [NSMutableArray arrayWithCapacity: USER_COLUMN_COUNT];
                
                for (int columnCount = 0; columnCount < USER_COLUMN_COUNT; columnCount++) {
                    if (columnCount == 0) { // id
                        [values addObject: [NSNumber numberWithLongLong: [results longLongIntForColumnIndex: columnCount]]];
                    } else { // string
                        [values addObject: [results stringForColumnIndex: columnCount]];
                    }
                }
                
                [fetchResults addObject: values];
            }
            
            if (i == 1) {
                NSLog(@"fetchResults count: %i", [fetchResults count]);    
            }
            
        }
        
    }];
}


// core data

- (void) insertCoreData {
    [self deleteAllCoreData];
    
    NSManagedObjectContext *managedObjectContext = [APP_DELEGATE managedObjectContext];
    
    NSString *benchmarkName = [NSString stringWithFormat: @"inserting %i records with core data", INSERT_RUNS];
    [Benchmark benchmark: benchmarkName withBlock: ^ {        
        int i;
        NSError *error;
        
        for (i = 1; i <= INSERT_RUNS; i++) {
            User *obj = [NSEntityDescription insertNewObjectForEntityForName: @"User" inManagedObjectContext: managedObjectContext];
            obj.firstName = @"Scott";
            obj.lastName = @"Taylor";
            obj.id = [NSNumber numberWithInt: i];

            if (![managedObjectContext save: &error]) {
                [NSException raise: @"SaveError" format: @"Couldn't save objects.  Error: %@", error];
            }
        }
    }];
}

- (void) queryAllCoreData {
    NSManagedObjectContext *managedObjectContext = [APP_DELEGATE managedObjectContext];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"User" inManagedObjectContext: [APP_DELEGATE managedObjectContext]];
    
    // Setup the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults: NO];
    [request setEntity: entity];
    
    __block NSError *error;
    

    [Benchmark benchmark: @"query all core data" withBlock: ^ {
        
        for (int i = 0; i < QUERY_ALL_RUNS; i++) {
            NSArray *fetchResults = [managedObjectContext executeFetchRequest: request error: &error];
            
            if (!fetchResults) {
                NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
                
                NSArray* detailedErrors = [[error userInfo] objectForKey: NSDetailedErrorsKey];
                
                if (detailedErrors != nil && [detailedErrors count] > 0) {
                    for (NSError* detailedError in detailedErrors) {
                        NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                    }
                } else {
                    NSLog(@"  %@", [error userInfo]);
                }
                
                [NSException raise: @"FetchError" format: @"Couldn't fetch objects from table"];
            }
            
            if (i == 0) {
                NSLog(@"fetchResults count: %i", [fetchResults count]);    
            }
        }
    }];
}

- (void) queryIdCoreData {
    NSManagedObjectContext *managedObjectContext = [APP_DELEGATE managedObjectContext];
    
    // Define our table/entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"User" inManagedObjectContext: [APP_DELEGATE managedObjectContext]];
    
    __block NSError *error;
    
    
    [Benchmark benchmark: @"query ids - core data" withBlock: ^ {
        
        for (int i = 1; i <= QUERY_ID_RUNS; i++) {
            // Setup the fetch request
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setReturnsObjectsAsFaults: NO];
            [request setEntity: entity];
            [request setPredicate: [NSPredicate predicateWithFormat: @"id = %i", i]];
            
            NSArray        *fetchResults = [managedObjectContext executeFetchRequest: request error: &error];
            
            if (!fetchResults) {
                NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
                
                NSArray* detailedErrors = [[error userInfo] objectForKey: NSDetailedErrorsKey];
                
                if (detailedErrors != nil && [detailedErrors count] > 0) {
                    for (NSError* detailedError in detailedErrors) {
                        NSLog(@"  DetailedError: %@", [detailedError userInfo]);
                    }
                } else {
                    NSLog(@"  %@", [error userInfo]);
                }
                
                [NSException raise: @"FetchError" format: @"Couldn't fetch objects from table"];
            }
            
            if (i == 1) {
                NSLog(@"fetchResults count: %i", [fetchResults count]);    
            }
        }
    }];

}

@end
