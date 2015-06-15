//
//  SnowCardA2.h
//  snow
//
//  Created by samuel maura on 6/5/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowTask.h"

@class SnowCardA2;

@protocol SnowCardA2Delegate <NSObject>
- (void)cell:(SnowCardA2 *)cell
    ActionButtonPressedFor:(SnowTask *)task
                   AtIndex:(NSIndexPath *)index;
@end

@interface SnowCardA2 : UITableViewCell

@property(nonatomic, strong) SnowTask *task;
@property(nonatomic, strong) NSIndexPath *cellPath;

@property(nonatomic, weak) id<SnowCardA2Delegate> delegate;

@property(strong, nonatomic) UILabel *listName;
@property(strong, nonatomic) UILabel *dueDate;
@property(strong, nonatomic) UILabel *taskTitle;

@property(strong, nonatomic) UIButton *taskOptions;

@property(strong, nonatomic) UIView *dataContainerView;
@property(strong, nonatomic) UIView *actionView;

@property(nonatomic, copy) void (^deleteTask)(void);
@property(nonatomic, copy) void (^completeTask)(void);

@end
