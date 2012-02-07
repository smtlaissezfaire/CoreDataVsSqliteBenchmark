//
//  AppDelegate.h
//  CoreDataVsSqliteView
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataVsSqlLite.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CoreDataVsSqlLite *tests;
}

@property (nonatomic, retain) CoreDataVsSqlLite *tests;
@property (strong, nonatomic) UIWindow *window;

- (id) managedObjectContext;

@end
