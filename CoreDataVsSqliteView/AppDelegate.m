//
//  AppDelegate.m
//  CoreDataVsSqliteView
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#define A(obj, objs...) \
[NSArray arrayWithObjects:obj, ## objs , nil]
#define D(val, key, vals...) \
[NSDictionary dictionaryWithObjectsAndKeys: val, key, ## vals , nil]


@implementation AppDelegate

@synthesize window = _window;
@synthesize sqliteConnection;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setupCoreData];
    [self setupFMDB];

    return YES;
}

//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    /*
//     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//     */
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    /*
//     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
//     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//     */
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application
//{
//    /*
//     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//     */
//}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    /*
//     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//     */
//}
//
//- (void)applicationWillTerminate:(UIApplication *)application
//{
//    /*
//     Called when the application is about to terminate.
//     Save data if appropriate.
//     See also applicationDidEnterBackground:.
//     */
//}

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

- (void)applicationWillTerminate:(UIApplication *)application {
    if ([sqliteConnection open]) {
        [sqliteConnection close];
    }
}

- (void) setupFMDB {
//    Database Creation
//    
//    An FMDatabase is created with a path to a SQLite database file. This path can be one of these three:
//    
//    A file system path. The file does not have to exist on disk. If it does not exist, it is created for you.
//        An empty string (@""). An empty database is created at a temporary location. This database is deleted with the FMDatabase connection is closed.
//        NULL. An in-memory database is created. This database will be destroyed with the FMDatabase connection is closed.
//        
//        FMDatabase *db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
    
    NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [applicationDocumentsDirectory stringByAppendingPathComponent:@"pureSqlite.sqlite"];

    
    sqliteConnection = [FMDatabase databaseWithPath: path];
    
    [sqliteConnection open];
    [self deleteAllSqlite];
}

- (void) deleteAllCoreData {
    NSError *error;
    
    NSPersistentStore *store = [[self.persistentStoreCoordinator persistentStores] objectAtIndex: 0];
    NSURL *storeURL = store.URL;
    
    [self.persistentStoreCoordinator removePersistentStore: store error: &error];
    [[NSFileManager defaultManager] removeItemAtPath: storeURL.path error: &error];
    
    persistentStoreCoordinator = nil;
    managedObjectContext = nil;
    managedObjectModel = nil;
    
    [self setupCoreData];
}

- (void) deleteAllSqlite {
    [sqliteConnection executeUpdate: @"drop table if exists users"];
    [sqliteConnection executeUpdate: @"create table users (id integer primary key, firstName varchar, lastName varchar)"];
}


@end
