//
//  SnowSearchResultsTVC.h
//  snow
//
//  Created by samuel maura on 5/20/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowDataManager.h"
#import "SnowListManager.h"
#import "SnowBaseTVC.h"
#import "SnowTaskDetailsTVC.h"
#import "SnowAppearanceManager.h"
#import "SnowCardA3.h"

@protocol SnowSearchResultsTVCDelegate <NSObject>

- (void)loadTask:(SnowTask *)task;

@end

@interface SnowSearchResultsTVC : SnowBaseTVC

@property(nonatomic, strong) NSArray *taskList;

@property(nonatomic, copy) void (^menuTapped)(void);

@property(nonatomic, weak) id<SnowSearchResultsTVCDelegate> delegate;

@end
