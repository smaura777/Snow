//
//  SnowMenuTVCA1.h
//  snow
//
//  Created by samuel maura on 5/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowCellTypeA1.h"
#import "SnowThemeSwitcher.h"
#import "SnowBaseTVC.h"

@interface SnowMenuTVCA1 : SnowBaseTVC
@property(nonatomic, copy) void (^appMenuSelected)(NSString *menuTitle);
@end
