//
//  SnowAppearanceManager.h
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowTheme.h"
#import "SnowBackground.h"
#import "SnowSound.h"
#import "SnowLoggingManager.h"

@interface SnowAppearanceManager : NSObject

@property(nonatomic, strong) SnowTheme *currentTheme;
@property(nonatomic, strong) SnowBackground *currentBackground;
@property(nonatomic, strong) SnowSound *currentAlertTone;

// Public Methods

+ (instancetype)sharedInstance;

- (void)saveDefaultTheme:(SnowTheme *)theme;
- (void)saveDefaultBackground:(SnowBackground *)bk;
- (void)saveDefaultAlertTone:(SnowSound *)tone;

@end
