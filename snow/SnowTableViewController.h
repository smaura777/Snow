//
//  SnowTableViewController.h
//  snow
//
//  Created by samuel maura on 3/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowDataManager.h"
#import "SnowCustomTransition.h"
#import "BackgroundLayer.h"
#import "SnowBaseTVC.h"
#import "SnowTaskDetailsTVC.h"
#import "SnowQuickTimerMasterTVC.h"
#import "SnowQuickTimerVC.h"
#import "UIImage+SnowImageUtils.h"
#import "SnowCardA.h"
#import "SnowCardA2.h"

@interface SnowTableViewController
    : SnowBaseTVC <UITextFieldDelegate, UIViewControllerTransitioningDelegate,
                   SnowTaskDetailsTVCDelegate, SnowQuickTimerMasterDelegate,
                   SnowCardA2Delegate>

//@property NSArray *localTblList;
//@property NSArray *localTblTask;
//@property NSMutableArray *listWithTasks;

@property(strong, nonatomic) NSDictionary *listTable;
@property(nonatomic, copy) void (^menuTapped)(void);

@end
