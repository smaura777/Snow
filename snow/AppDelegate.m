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

@interface AppDelegate ()

@end

@implementation AppDelegate

//   [UIColor colorWithRed:0 green:.54 blue:.54 alpha:1]

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  application.applicationIconBadgeNumber = 0;

  NSError *setCategoryErr;

  [ [AVAudioSession sharedInstance]
      setCategory:AVAudioSessionCategoryAmbient
      withOptions:AVAudioSessionCategoryOptionMixWithOthers
            error:&setCategoryErr ];
  /*
[[AVAudioSession sharedInstance]
setCategory:AVAudioSessionCategoryOptionMixWithOthers
                                       error:&setCategoryErr];
*/

  // Override point for customization after application launch.

  [SnowDataManager sharedInstance];

  [SnowAppearanceManager sharedInstance];

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
  NSLog(@"called %s", __func__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
  NSLog(@"called %s", __func__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
  NSLog(@"called %s", __func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
  NSLog(@"called %s", __func__);
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {
  NSLog(@"Ready for local notifications ");
  [[SnowNotificationManager sharedInstance] setSnowLocalNotificationOn:YES];
  [[SnowNotificationManager sharedInstance] fireNotifications];
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"Ready for remote notifications ");
}

- (void)application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification {
  application.applicationIconBadgeNumber = 0;

  NSLog(@"************** Received local notification ");

  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Task Alert"
                                          message:notification.alertBody
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *action1 =
      [UIAlertAction actionWithTitle:@"close"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action) {
                                 
                                 
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
                                   clearNotification:notification ];
                             }];

  [alert addAction:action1];
  [alert addAction:action2];
  [alert addAction:action3];

  [self.window.rootViewController presentViewController:alert
                                               animated:YES
                                             completion:nil];
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

@end
