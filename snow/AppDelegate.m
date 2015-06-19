//
//  AppDelegate.m
//  snow
//
//  Created by samuel maura on 3/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "AppDelegate.h"
#import "SnowDataManager.h"
#import "SnowMainContainerVC.h"
#import "SnowNotificationManager.h"
#import "SnowAppearanceManager.h"
#import "UIImage+SnowImageUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "SnowLoggingManager.h"

@interface AppDelegate () <AVAudioPlayerDelegate>

@end

@implementation AppDelegate {
  AVAudioPlayer *_aPlayer;
}

//   [UIColor colorWithRed:0 green:.54 blue:.54 alpha:1]

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  //  if (([UIApplication
  //  sharedApplication].currentUserNotificationSettings.types &
  //       UIUserNotificationTypeBadge)) {
  //    application.applicationIconBadgeNumber = 0;
  //  }

  NSError *setCategoryErr;

  [[AVAudioSession sharedInstance]
      setCategory:AVAudioSessionCategoryAmbient
      withOptions:AVAudioSessionCategoryOptionMixWithOthers
            error:&setCategoryErr];
  /*
[[AVAudioSession sharedInstance]
setCategory:AVAudioSessionCategoryOptionMixWithOthers
                                       error:&setCategoryErr];
*/

  // Override point for customization after application launch.

  [self setupAnalytics];
  [SnowDataManager sharedInstance];
  [SnowAppearanceManager sharedInstance];
  [SnowLoggingManager sharedInstance].mode = 0;
  [[SnowNotificationManager sharedInstance] clearBadgeIndicator];
  [[SnowNotificationManager sharedInstance] getAllPendingNotifications];

  [self applyTheme];

  SnowMainContainerVC *snow = [[SnowMainContainerVC alloc] init];
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // self.window.backgroundColor = [UIColor cyanColor];
  [self.window setRootViewController:snow];
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
    
    // Remove badge
    [[SnowNotificationManager sharedInstance] clearBadgeIndicator];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {

  [[SnowNotificationManager sharedInstance] setSnowLocalNotificationOn:YES];
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}

- (void)application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification {
  
  // Clear badge
    [[SnowNotificationManager sharedInstance] clearBadgeIndicator];


  UIAlertController *alert;

  NSDictionary *timerInfo = notification.userInfo;
  if ([timerInfo valueForKey:@"TimerItemKey"]) {

    [self prepPlayer];

    alert = [UIAlertController
        alertControllerWithTitle:@"Timer"
                         message:notification.alertBody
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action1 =
        [UIAlertAction actionWithTitle:@"close"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action) {

                                 if (_aPlayer && ([_aPlayer isPlaying])) {
                                   [_aPlayer stop];
                                 }

                               }];

    [alert addAction:action1];
    if (_aPlayer && (![_aPlayer isPlaying])) {
      [_aPlayer play];
    }

  } else {

    alert = [UIAlertController
        alertControllerWithTitle:@"Task Alert"
                         message:notification.alertBody
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action1 =
        [UIAlertAction actionWithTitle:@"close"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action){

                               }];

    UIAlertAction *action2 =
        [UIAlertAction actionWithTitle:@"Mark as completed"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                 [[SnowNotificationManager sharedInstance]
                                     completeNotification:notification];
                               }];

    UIAlertAction *action3 =
        [UIAlertAction actionWithTitle:@"clear"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                 [[SnowNotificationManager sharedInstance]
                                     clearNotification:notification];
                               }];

    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
  }

  if (_topVC == nil) {

    [self.window.rootViewController presentViewController:alert
                                                 animated:YES
                                               completion:nil];
  } else {

    [_topVC presentViewController:alert animated:YES completion:nil];
  }
}

- (void)prepPlayer {

  _aPlayer = nil;

  NSError *audioErr;

  NSString *defaultSoundFileNameWithExtension =
      [[SnowAppearanceManager sharedInstance] currentAlertTone].soundName;

  NSString *defaultSoundFileNameExtension =
      [[defaultSoundFileNameWithExtension componentsSeparatedByString:@"."]
          objectAtIndex:1];
  NSString *defaultSoundFileName =
      [[defaultSoundFileNameWithExtension componentsSeparatedByString:@"."]
          objectAtIndex:0];

  NSString *alertSoundFilePath =
      [[NSBundle mainBundle] pathForResource:defaultSoundFileName
                                      ofType:defaultSoundFileNameExtension];

  if (!alertSoundFilePath) {
    // NSLog(@"Could not find sound file ");
  }

  NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:alertSoundFilePath];

  _aPlayer =
      [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&audioErr];

  _aPlayer.delegate = self;

  [_aPlayer prepareToPlay];

  _aPlayer.numberOfLoops = 1; // infinite
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
}

- (void)applyTheme {

  //  UIColor *tableBC =
  //      [[SnowAppearanceManager sharedInstance] currentTheme]
  //          .ternary;
  //  UIColor *navBarBC =
  //      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  //  UIImage *navBarBI = [UIImage imageWithColor:navBarBC];
  //
  //  UIColor *navBarTintC =
  //      [[SnowAppearanceManager sharedInstance] currentTheme].secondary;

  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];

  /*
  [[UINavigationBar appearance] setBackgroundImage:navBarBI
                                     forBarMetrics:UIBarMetricsDefault];

  [[UINavigationBar appearance] setTintColor:navBarTintC];

  [[UITableView appearance] setBackgroundColor:tableBC];

  [[UINavigationBar appearance] setTitleTextAttributes:
   @{NSForegroundColorAttributeName:[UIColor whiteColor],
     NSFontAttributeName:[UIFont fontWithName:@"AvenirNextCondensed-Medium"
  size:28]}];

  */
}

#pragma mark - Google Analytics setup
- (void)setupAnalytics {
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  [GAI sharedInstance].dispatchInterval = 30;

  [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];

  [[GAI sharedInstance] trackerWithTrackingId:@"UA-59456103-2"];
  
   // Disable IFDA
    [[[GAI sharedInstance] defaultTracker] setAllowIDFACollection:NO];
}

@end
