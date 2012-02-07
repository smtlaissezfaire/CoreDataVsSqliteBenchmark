//
//  CoreDataVsSqlLite.m
//  CoreDataVsSqlLite
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataVsSqlLite.h"

@interface CoreDataVsSqlLite (Private)
- (void) setup;
- (void) setupCoreData;
- (void) setupFMDB;
- (NSString *) applicationDocumentsDirectory;
@end

#define A(obj, objs...) \
[NSArray arrayWithObjects:obj, ## objs , nil]
#define D(val, key, vals...) \
[NSDictionary dictionaryWithObjectsAndKeys: val, key, ## vals , nil]



@implementation CoreDataVsSqlLite

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}

- (void) setup {
    [self setupCoreData];
    [self setupFMDB];
}

- (void) setupCoreData {
    [self managedObjectContext];
    [self managedObjectModel];
    [self persistentStoreCoordinator];
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }


    return managedObjectContext;
}

- (NSManagedObjectModel *) managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }

    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [applicationDocumentsDirectory stringByAppendingPathComponent:@"CoreDataSqlite.sqlite"];
    NSURL *storeUrl = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = D([NSNumber numberWithBool: YES], NSMigratePersistentStoresAutomaticallyOption,
                              [NSNumber numberWithBool: YES], NSInferMappingModelAutomaticallyOption);
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeUrl
                                                         options:options
                                                           error:&error]) {
        NSLog(@"Problem with PersistentStoreCoordinator: %@", error);
        
        // Clear for now
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:storeUrl
                                                             options:options
                                                               error:&error]) {
            NSLog(@"SUPER BAD PROBLEM with PersistentStoreCoordinator: %@", error);
        }
    }
    
    return persistentStoreCoordinator;
}

- (NSString *) applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) setupFMDB {

}

@end
