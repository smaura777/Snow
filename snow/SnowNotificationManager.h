//
//  SnowNotificationManager.h
//  snow
//
//  Created by samuel maura on 4/6/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowTask.h"
#import "SnowList.h"
#import "SnowTimer.h"


extern NSString *SNOW_COMPLETE_NOTIF;
extern NSString *SNOW_CLEAR_NOTIF;

@interface SnowNotificationManager : NSObject

@property(nonatomic, assign, getter=isNotificationOn)
    BOOL SnowLocalNotificationOn;

@property(nonatomic, strong) NSMutableArray *pendingNotifications;
@property(nonatomic, copy) NSMutableArray *scheduledNotifications;

+ (instancetype)sharedInstance;

- (void)scheduleNotificationWithMessage:(NSString *)title
                               FireDate:(NSDate *)fire
                              Frequency:(NSCalendarUnit)frequency;

// Main interface
- (void)scheduleNotificationWithTask:(SnowTask *)task;
- (void)unscheduleNotificationWithTask:(SnowTask *)task;

- (void)unscheduleNotificationsWithList:(SnowList *)list;

- (void)fireNotifications;
- (void)completeNotification:(UILocalNotification *)notif;
- (void)clearNotification:(UILocalNotification *)notif;

// Timers
- (void)scheduleNotificationWithTimerObject:(SnowTimer *)tm;
- (void)unscheduleNotificationWithTimerObject:(SnowTimer *)tm;

@end