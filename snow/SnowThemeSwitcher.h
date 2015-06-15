//
//  SnowThemeSwitcher.h
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowAppearanceManager.h"
#import "SnowBaseTVC.h"

@interface SnowThemeSwitcher : SnowBaseTVC

@property NSArray *themeNames;
@property(nonatomic, strong) SnowTheme *selectedTheme;

@end
