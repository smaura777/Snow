//
//  SnowCardA.h
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowCardA.h"

@interface SnowCardA : UITableViewCell

@property(weak, nonatomic) IBOutlet UILabel *listName;
@property(weak, nonatomic) IBOutlet UILabel *dueDate;
@property(weak, nonatomic) IBOutlet UILabel *taskTitle;
@property(weak, nonatomic) IBOutlet UIView *dataContainerView;

//@property (weak,nonatomic) SnowTask *task;
@property(nonatomic, copy) void (^deleteTask)(void);
@property(nonatomic, copy) void (^completeTask)(void);

@end
