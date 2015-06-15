//
//  SnowAllPendingTaskForList.h
//  snow
//
//  Created by samuel maura on 6/3/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowTaskDetailsTVC.h"
#import "SnowListManager.h"
#import "SnowCardA2.h"

@interface SnowAllPendingTaskForList : SnowBaseTVC <SnowTaskDetailsTVCDelegate, SnowCardA2Delegate >
@property(strong, nonatomic) NSDictionary *listTable;
@property (nonatomic,strong) SnowList *list;

@end
