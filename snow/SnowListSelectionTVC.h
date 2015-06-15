//
//  SnowListSelectionTVC.h
//  snow
//
//  Created by samuel maura on 3/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowDataManager.h"
#import "SnowBaseTVC.h"
#import "SnowAppearanceManager.h"

@interface SnowListSelectionTVC : SnowBaseTVC

@property(nonatomic, strong) NSArray *allList;
@property(nonatomic, strong) NSIndexPath *lastSelection;
@property(nonatomic, copy) void (^updateSelectedList)(SnowList *item);
@property(nonatomic, strong) SnowList *selectedList;

- (void)hightlightInitialSelectionWith:(SnowList *)list;

@end
