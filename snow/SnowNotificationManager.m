//
//  SnowNotificationManager.m
//  snow
//
//  Created by samuel maura on 4/6/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowNotificationManager.h"
#import "SnowDataManager.h"
#import "SnowAppearanceManager.h"
#import "SnowListManager.h"

NSString *SNOW_COMPLETE_NOTIF = @"SNOW_COMPLETE_NOTIF";
NSString *SNOW_CLEAR_NOTIF = @"SNOW_CLEAR_NOTIF";

@implementation SnowNotificationManager

+ (instancetype)sharedInstance {
  static SnowNotificationManager *notificationManager = nil;
  static dispatch_once_t token;

  if (notificationManager == nil) {
    dispatch_once(&token, ^{
      notificationManager = [[SnowNotificationManager alloc] init];
    });
  }

  return notificationManager;
}

- (instancetype)init {
  if (self = [super init]) {
    _SnowLocalNotificationOn = NO;
    _pendingNotifications = [NSMutableArray new];
    _scheduledNotifications = [NSMutableArray new];
  }

  return self;
}

- (void)scheduleNotificationWithTask:(SnowTask *)task {
  NSCalendar *userCal = [NSCalendar currentCalendar];
  NSDateComponents *nextFireDate = [[NSDateComponents alloc] init];

  // NSTimeInterval nextFireDate = 0;

  if ((task == nil) || ([task.title length] == 0) || (task.itemID == nil) ||
      ([task.itemID length] == 0)) {
    return;
  }

  [self enableNotifications];
  UILocalNotification *noti = [[UILocalNotification alloc] init];

  if ([task.repeat isEqualToString:@"daily"]) {
    noti.repeatInterval = NSCalendarUnitDay;
    [nextFireDate setDay:1];
  } else if ([task.repeat isEqualToString:@"weekly"]) {
    noti.repeatInterval = NSCalendarUnitWeekday;
    [nextFireDate setWeekday:1];
  } else if ([task.repeat isEqualToString:@"monthly"]) {
    noti.repeatInterval = NSCalendarUnitMonth;
    [nextFireDate setMonth:1];
  } else if ([task.repeat isEqualToString:@"yearly"]) {
    noti.repeatInterval = NSCalendarUnitYear;
    [nextFireDate setYear:1];
  }

  if ([task.reminder compare:[NSDate date]] <= 0) {
    // NSLog(@"Current alert fire date <= now , will fire next time then");
    NSDate *nextNotifyDate = [userCal dateByAddingComponents:nextFireDate
                                                      toDate:task.reminder
                                                     options:0];
    // NSLog(@"Next Fire date %@", [nextNotifyDate description]);

    //   we adjust the next firing date only for repeating tasks
    if (![task.repeat isEqualToString:@"none"]) {
      noti.fireDate = nextNotifyDate;
    }

  } else {
    noti.fireDate = task.reminder;
  }

  noti.soundName = UILocalNotificationDefaultSoundName;
  noti.timeZone = [NSTimeZone defaultTimeZone];
  noti.alertBody = task.title;
  noti.applicationIconBadgeNumber = 1;
  noti.alertAction = @"Ok";

  NSDictionary *infoDict =
      [NSDictionary dictionaryWithObject:task.itemID forKey:@"TaskItemKey"];
  noti.userInfo = infoDict;

  [_pendingNotifications addObject:noti];

  UILocalNotification *existing = nil;

  // clear out existing notification for task
  if ((existing = [self queryScheduledNotificationForTask:task]) != nil) {
    [self cancelLocalNotification:existing];
  }

  [self fireNotifications];
}

- (UILocalNotification *)queryScheduledNotificationForTask:(SnowTask *)task {
  NSArray *notifications =
      [[UIApplication sharedApplication] scheduledLocalNotifications];
  for (UILocalNotification *item in notifications) {
    NSString *key = [item.userInfo objectForKey:@"TaskItemKey"];
    if ([key isEqualToString:task.itemID]) {
      return item;
    }
  }

  return nil;
}

- (void)cancelLocalNotification:(UILocalNotification *)noti {
  if (noti) {
    [[UIApplication sharedApplication] cancelLocalNotification:noti];
  }
}

- (void)unscheduleNotificationWithTask:(SnowTask *)task {
  NSArray *notifications =
      [[UIApplication sharedApplication] scheduledLocalNotifications];
  for (UILocalNotification *item in notifications) {
    NSString *key = [item.userInfo objectForKey:@"TaskItemKey"];
    if ([key isEqualToString:task.itemID]) {
      [[UIApplication sharedApplication] cancelLocalNotification:item];
    }
  }
}

- (void)unscheduleNotificationsWithList:(SnowList *)list {
  NSArray *taskList = [[SnowDataManager sharedInstance] cachedTask];
  for (SnowTask *item in taskList) {
    if ([item.listID isEqualToString:list.itemID]) {
      [self unscheduleNotificationWithTask:item];
    }
  }
}

//- (void)updateNotificationWithTassk:(SnowTask*)task {
//  NSArray* notifications =
//      [[UIApplication sharedApplication] scheduledLocalNotifications];
//  for (UILocalNotification* item in notifications) {
//    NSString* key = [item.userInfo objectForKey:@"TaskItemKey"];
//    if ([key isEqualToString:task.itemID]) {
//      [[UIApplication sharedApplication] cancelLocalNotification:item];
//    }
//  }
//
//  [self scheduleNotificationWithTask:task];
//}

- (void)scheduleNotificationWithMessage:(NSString *)title
                               FireDate:(NSDate *)fire
                              Frequency:(NSCalendarUnit)frequency {
  if ((title == nil) || ([title length] == 0) || (fire == nil)) {
    return;
  }

  [self enableNotifications];

  UILocalNotification *noti = [[UILocalNotification alloc] init];

  noti.fireDate = fire;

  if (frequency) {
    noti.repeatInterval = frequency;
  }

  noti.soundName = UILocalNotificationDefaultSoundName;
  noti.timeZone = [NSTimeZone defaultTimeZone];
  noti.alertBody = title;
  noti.applicationIconBadgeNumber = 1;
  noti.alertAction = @"Ok";

  [_pendingNotifications addObject:noti];
  [self fireNotifications];
}

- (void)fireNotifications {
  if (!_SnowLocalNotificationOn) {
    // NSLog(@"Notifications not enabled ");
    // NSLog(@"Notifications Pending %ld", [_pendingNotifications count]);
    return;
  }

  for (UILocalNotification *item in _pendingNotifications) {
    [[UIApplication sharedApplication] scheduleLocalNotification:item];
    [_scheduledNotifications addObject:item];
  }

  [_pendingNotifications removeAllObjects];

  // NSLog(@"Notifications Scheduled  %ld", [_scheduledNotifications count]);
}

- (void)enableNotifications {
  static dispatch_once_t token;

  dispatch_once(&token, ^{
    UIUserNotificationType types = UIUserNotificationTypeBadge |
                                   UIUserNotificationTypeSound |
                                   UIUserNotificationTypeAlert;

    UIUserNotificationSettings *mySettings =
        [UIUserNotificationSettings settingsForTypes:types categories:nil];

    [[UIApplication sharedApplication]
        registerUserNotificationSettings:mySettings];
  });
}

#pragma mark - Timers

// Timers
- (void)scheduleNotificationWithTimerObject:(SnowTimer *)tmo {

  if (tmo == nil) {
    return;
  }

  // NSLog(@"%s ", __func__);

  SnowTimer *tm =
      [[SnowDataManager sharedInstance] fetchSavedTimerForKey:tmo.timerName];

  if (tm != nil && (tm.timerState == 2)) {
    // Has timer expired
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm.startDate timeIntervalSince1970];

    if ((tm.timerValue - tdf) <= 0) {
      return;
    } else {

      NSTimeInterval secondsLeft =
          [[NSDate date] timeIntervalSince1970] + tm.timerValue;

      NSDate *tmFireDate = [NSDate dateWithTimeIntervalSince1970:secondsLeft];

      NSDateFormatter *fm = [[NSDateFormatter alloc] init];
      fm.dateFormat = @"E MM DD YYYY h:m:ss ";
      // NSLog(@"Timer should fire on %@", [fm stringFromDate:tmFireDate]);

      [self enableNotifications];
      UILocalNotification *noti = [[UILocalNotification alloc] init];

      noti.fireDate = tmFireDate;
      noti.soundName = [[SnowAppearanceManager sharedInstance] currentAlertTone]
                           .soundName; // UILocalNotificationDefaultSoundName;
      noti.timeZone = [NSTimeZone defaultTimeZone];
      noti.alertBody =
          [NSString stringWithFormat:@" time's up : %@", tm.timerName];
      noti.applicationIconBadgeNumber = 1;
      noti.alertAction = @"Ok";

      NSDictionary *infoDict =
          [NSDictionary dictionaryWithObject:tm.itemId forKey:@"TimerItemKey"];
      noti.userInfo = infoDict;

      [_pendingNotifications addObject:noti];

      UILocalNotification *existing = nil;

      // clear out existing notification for task
      if ((existing = [self queryScheduledNotificationForTimerObject:tm]) !=
          nil) {
        [self cancelLocalNotification:existing];
      }

      [self fireNotifications];
    }
  }
}

- (void)unscheduleNotificationWithTimerObject:(SnowTimer *)tmo {

  if (tmo == nil) {
    return;
  }

  // NSLog(@"%s ", __func__);

  NSArray *notifications =
      [[UIApplication sharedApplication] scheduledLocalNotifications];
  for (UILocalNotification *item in notifications) {
    NSString *key = [item.userInfo objectForKey:@"TimerItemKey"];
    if ([key isEqualToString:tmo.itemId]) {
      [[UIApplication sharedApplication] cancelLocalNotification:item];
    }
  }
}

- (UILocalNotification *)queryScheduledNotificationForTimerObject:
    (SnowTimer *)tmo {
  NSArray *notifications =
      [[UIApplication sharedApplication] scheduledLocalNotifications];
  for (UILocalNotification *item in notifications) {
    NSString *key = [item.userInfo objectForKey:@"TimerItemKey"];
    if ([key isEqualToString:tmo.itemId]) {
      return item;
    }
  }

  return nil;
}

#pragma mark - NOTIFICATION ACTIONS

- (void)completeNotification:(UILocalNotification *)notif {
  // NSLog(@"Received forground notification for %@ ", notif.alertBody);

  NSString *taskId = [notif.userInfo objectForKey:@"TaskItemKey"];

  if (taskId == nil) {
    return;
  }

  SnowListManager *listManager = [SnowListManager new];
  [listManager refresh];

  NSArray *taskList = [listManager fetchTasks];

  SnowTask *completedTask;

  for (SnowTask *t in taskList) {
    if ([t.itemID isEqualToString:taskId]) {
      completedTask = t;
      break;
    }
  }

  completedTask.completed = YES;
  [[SnowDataManager sharedInstance]
                 updateTask:completedTask
      WithCompletionHandler:^(NSError *error, NSDictionary *task) {
        // Send Notification
        NSNotification *completeNotification =
            [NSNotification notificationWithName:SNOW_COMPLETE_NOTIF
                                          object:nil];

        [[NSNotificationCenter defaultCenter]
            postNotification:completeNotification];
      }];

  // Complete task
}

- (void)clearNotification:(UILocalNotification *)notif {
  // NSLog(@"Received forground notification for %@ ", notif.alertBody);

  NSString *taskId = [notif.userInfo objectForKey:@"TaskItemKey"];

  if (taskId == nil) {
    return;
  }

  SnowListManager *listManager = [SnowListManager new];
  [listManager refresh];

  NSArray *taskList = [listManager fetchTasks];

  SnowTask *deleteTask;

  for (SnowTask *t in taskList) {
    if ([t.itemID isEqualToString:taskId]) {
      deleteTask = t;
      break;
    }
  }

  deleteTask.deleted = YES;
  [[SnowDataManager sharedInstance]
                 updateTask:deleteTask
      WithCompletionHandler:^(NSError *error, NSDictionary *task) {
        // Send Notification
        NSNotification *clearNotification =
            [NSNotification notificationWithName:SNOW_CLEAR_NOTIF object:nil];

        [[NSNotificationCenter defaultCenter]
            postNotification:clearNotification];
      }];
}

@end
