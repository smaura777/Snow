//
//  SnowTaskDetailsTVC.h
//  snow
//
//  Created by samuel maura on 5/8/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowDataManager.h"
#import "SnowAppearanceManager.h"

@protocol SnowTaskDetailsTVCDelegate <NSObject>

- (void)popDetail;

@end

@interface SnowTaskDetailsTVC : SnowBaseTVC

@property(strong, nonatomic) SnowTask *detailTask;
@property(strong, nonatomic) SnowList *parentList;
@property(weak, nonatomic) id<SnowTaskDetailsTVCDelegate> delegate;

@end
