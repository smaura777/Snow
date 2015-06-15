//
//  SnowListAllTVC.h
//  snow
//
//  Created by samuel maura on 4/6/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowAllPendingTaskForList.h"

@interface SnowListAllTVC : SnowBaseTVC

@property NSArray *completeList;
@property(nonatomic, copy) void (^menuTapped)(void);

@end
