//
//  SnowReminderRepeatTableViewController.h
//  snow
//
//  Created by samuel maura on 4/3/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowAppearanceManager.h"

@interface SnowReminderRepeatTableViewController : SnowBaseTVC

@property(nonatomic, copy) void (^repeatSelected)(NSInteger item);
@property(nonatomic, strong) NSArray *repeatOptions;
@property(nonatomic, assign) NSUInteger selectedOption;
@property(nonatomic, copy) NSString *currentFrequency;

@end
