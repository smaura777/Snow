//
//  SnowTaskPriority.h
//  snow
//
//  Created by samuel maura on 5/14/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowAppearanceManager.h"

@interface SnowTaskPriority : SnowBaseTVC

@property(nonatomic, strong) NSArray *priorities;
@property(nonatomic, strong) NSIndexPath *lastSelection;
@property(nonatomic, copy) void (^updatePriority)(int priority);

@property(nonatomic, assign) int selectedPriority;
@property(nonatomic, assign) int initialPriority;

@end
