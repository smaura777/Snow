//
//  SnowQuickTimerMasterTVC.h
//  snow
//
//  Created by samuel maura on 5/21/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowQuickTimerDetailVC.h"
#import "SnowTimer.h"

// All Preset - no custom

// 2 3,,5,10
// 15, 20,25,30
// 45,120,150,180

@protocol SnowQuickTimerMasterDelegate <NSObject>

- (void)closeTimerView;

@end

@interface SnowQuickTimerMasterTVC : UITableViewController
@property(nonatomic, strong) NSMutableArray *timers;
@property(nonatomic, weak) id<SnowQuickTimerMasterDelegate> delegate;
@end
