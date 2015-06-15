//
//  SnowTaskAllTVC.h
//  snow
//
//  Created by samuel maura on 4/8/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowDataManager.h"
#import "SnowBaseTVC.h"
#import "SnowTaskDetailsTVC.h"
#import "SnowCardA2.h"

@interface SnowTaskAllTVC : SnowBaseTVC <SnowTaskDetailsTVCDelegate , SnowCardA2Delegate>
@property NSArray *tasks;

@property NSInteger role;
// 0 = all tasks for list
// 1 = all completed tasks
// 2 = all deleted tasks

@property SnowList *selectedList;

@property(nonatomic, copy) void (^menuTapped)(void);

@end
