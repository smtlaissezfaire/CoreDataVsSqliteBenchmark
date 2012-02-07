//
//  AppDelegate.h
//  CoreDataVsSqliteView
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "FMDatabase.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSManagedObjectModel         *managedObjectModel;
    NSManagedObjectContext       *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    FMDatabase *sqliteConnection;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) FMDatabase *sqliteConnection;

- (NSManagedObjectContext *) managedObjectContext;
- (NSManagedObjectModel *) managedObjectModel;
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator;
- (void) setupCoreData;
- (void) setupFMDB;
- (NSString *) applicationDocumentsDirectory;
- (void) deleteAllCoreData;
- (void) deleteAllSqlite;

@end
