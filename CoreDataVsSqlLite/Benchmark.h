//
//  Benchmark.h
//  CoreDataVsSqlLite
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Benchmark : NSObject

+ (NSTimeInterval) benchmark: (void (^)()) block;
+ (void) benchmark: (NSString *) name withBlock: (void (^)()) block;

@end
