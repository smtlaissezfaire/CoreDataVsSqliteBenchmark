//
//  ViewController.h
//  CoreDataVsSqliteView
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void) runBenchmarks;

- (void) insertSqlLite;
- (void) queryAllSqliteLite;
- (void) queryIdSqlite;

- (void) insertCoreData;
- (void) queryAllCoreData;
- (void) queryIdCoreData;


@end
