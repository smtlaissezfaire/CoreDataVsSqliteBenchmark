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

#define APP_DELEGATE    ((AppDelegate *) [[UIApplication sharedApplication] delegate])

@implementation ViewController

- (void)viewDidLoad
{
    [self runSqliteBenchmarks];
    [self runCoreDataBenchmarks];
    [super viewDidLoad];
}

- (void) runSqliteBenchmarks {
    [self insertSqlLite];
    [self queryAllSqliteLite];
    [self queryFirstNameSqlite];
}

- (void) runCoreDataBenchmarks {
    [self insertCoreData];
    [self queryAllCoreData];
    [self queryFirstNameCoreData];
}

// sqlite
- (void) insertSqlLite {

}

- (void) queryAllSqliteLite {

}

- (void) queryFirstNameSqlite {

}


// core data

#define INSERT_RUNS 10

- (void) insertCoreData {
    NSManagedObjectContext *managedObjectContext = [APP_DELEGATE managedObjectContext];
    
    NSString *benchmarkName = [NSString stringWithFormat: @"inserting %i records with core data", INSERT_RUNS];
    [Benchmark benchmark: benchmarkName withBlock: ^ {        
        int i;
        NSError *error;
        
        for (i = 0; i < INSERT_RUNS; i++) {
            for (int i = 0; i < INSERT_RUNS; i++) {
                User *obj = [NSEntityDescription insertNewObjectForEntityForName: @"User" inManagedObjectContext: managedObjectContext];
                obj.firstName = @"Scott";
                obj.lastName = @"Taylor";
                obj.id = [NSNumber numberWithInt: i];
            }

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
        NSArray        *fetchResults = [managedObjectContext executeFetchRequest: request error: &error];
        NSMutableArray *mutableFetchResults = [fetchResults mutableCopy];

        if (!mutableFetchResults) {
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
        
        NSLog(@"mutableFetchResults: %@", mutableFetchResults);
    }];
}

- (void) queryFirstNameCoreData {

}

@end
