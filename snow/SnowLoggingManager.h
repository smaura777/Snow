//
//  SnowLoggingManager.h
//  snow
//
//  Created by samuel maura on 6/17/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnowLoggingManager : NSObject

@property(nonatomic, assign) NSUInteger mode; // 0, 1, 2

+ (instancetype)sharedInstance;

- (void)SnowLog:(NSString *)format, ...;

@end
