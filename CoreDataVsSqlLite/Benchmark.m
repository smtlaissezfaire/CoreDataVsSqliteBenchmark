//
//  Benchmark.m
//  CoreDataVsSqlLite
//
//  Created by Scott Taylor on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Benchmark.h"

@implementation Benchmark

+ (NSTimeInterval) benchmark: (void (^)()) block {
    NSDate *t1, *t2;
    
    t1 = [NSDate date];
    block();
    t2 = [NSDate date];
    return [t2 timeIntervalSinceDate: t1];
}

+ (void) benchmark: (NSString *) name withBlock: (void (^)()) block {
    [self benchmark: ^{
        NSLog(@"\n");
        NSLog(@"--- starting benchmark: %@ --- ", name);
        NSTimeInterval time = [self benchmark: block];
        NSLog(@"--- completed benchmark: %@, time: %f ---", name, time);
        
    }];
}


@end
