//
//  SnowTimer.h
//  snow
//
//  Created by samuel maura on 5/21/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnowTimer : NSObject
@property(nonatomic, copy) NSString *itemId;
@property(nonatomic, assign) NSTimeInterval timerValue;
@property(nonatomic, copy) NSString *timerName;

@property(nonatomic, strong) NSDate *startDate;

// 0 = off // 1 = Paused // 2 = running
@property(nonatomic, assign) NSInteger timerState;

@end
