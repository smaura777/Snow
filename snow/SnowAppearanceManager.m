//
//  SnowAppearanceManager.m
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowAppearanceManager.h"
#import "SnowDataManager.h"

@implementation SnowAppearanceManager

+ (instancetype)sharedInstance {
  static SnowAppearanceManager *appearanceManager = nil;
  static dispatch_once_t token;

  if (appearanceManager == nil) {
    dispatch_once(&token, ^{
      appearanceManager = [[SnowAppearanceManager alloc] init];
    });
  }

  return appearanceManager;
}

- (instancetype)init {
  if (self = [super init]) {

    // Default color theme
    _currentTheme = [[SnowDataManager sharedInstance] fetchDefaultTheme];

    if (_currentTheme == nil) {
      SnowTheme *defaultTheme = [[SnowTheme alloc] initWithThemeName:nil];
      _currentTheme = defaultTheme;
    }

    // Default background image
    _currentBackground =
        [[SnowDataManager sharedInstance] fetchDefaultBackground];

    if (_currentBackground == nil) {
      SnowBackground *defaultBackground =
          [[SnowBackground alloc] initWithBackgroundName:nil];

      _currentBackground = defaultBackground;
    }

    // Default alert tone
    _currentAlertTone = [[SnowDataManager sharedInstance] fetchDefaultSound];

    if (_currentAlertTone == nil) {
      _currentAlertTone = [[SnowSound alloc] initWithSoundName:nil];
    }
  }

  return self;
}

#pragma mark - theme

- (void)saveDefaultTheme:(SnowTheme *)theme {
  [[SnowDataManager sharedInstance] updateDefaultTheme:theme];
}

#pragma mark - Background image

- (void)saveDefaultBackground:(SnowBackground *)bk {
  [[SnowDataManager sharedInstance] updateDefaultBackground:bk];
}

#pragma mark - alert tones
- (void)saveDefaultAlertTone:(SnowSound *)tone {
  [[SnowDataManager sharedInstance] updateDefaultSound:tone];
}

@end
