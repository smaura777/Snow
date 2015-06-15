//
//  SnowTheme.h
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

// Colors definitions

#define kSnowColor_GRAY                                                        \
  [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.7 alpha:0.99]
#define kSnowColor_TURQUOISE                                                   \
  [UIColor colorWithHue:0.48 saturation:0.3 brightness:0.9 alpha:0.99]
#define kSnowColor_PURPLE                                                      \
  [UIColor colorWithHue:0.82 saturation:0.9 brightness:1.0 alpha:0.99]
#define kSnowColor_RED                                                         \
  [UIColor colorWithHue:0.97 saturation:0.9 brightness:0.9 alpha:0.99]
#define kSnowColor_ORANGE                                                      \
  [UIColor colorWithHue:0.05 saturation:0.9 brightness:0.9 alpha:0.99]
#define kSnowColor_YELLOW                                                      \
  [UIColor colorWithHue:0.15 saturation:0.85 brightness:0.90 alpha:0.99]
#define kSnowColor_GREEN                                                       \
  [UIColor colorWithHue:0.35 saturation:0.9 brightness:0.9 alpha:0.99]
#define kSnowColor_BLUE                                                        \
  [UIColor colorWithHue:0.55 saturation:0.9 brightness:0.95 alpha:0.99]
#define kSnowColor_WHITE                                                       \
  [UIColor colorWithHue:0.99 saturation:0.01 brightness:0.99 alpha:0.99]
#define kSnowColor_WHITE_OPAQUE                                                \
  [UIColor colorWithHue:0.99 saturation:0.01 brightness:1.0 alpha:1.0]

// Secondary

#define kSnowColor_GRAY_DARK                                                   \
  [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.6 alpha:0.99]
#define kSnowColor_TURQUOISE_DARK                                              \
  [UIColor colorWithHue:0.48 saturation:0.3 brightness:0.8 alpha:0.99]
#define kSnowColor_PURPLE_DARK                                                 \
  [UIColor colorWithHue:0.82 saturation:0.9 brightness:0.9 alpha:0.99]
#define kSnowColor_RED_DARK                                                    \
  [UIColor colorWithHue:0.97 saturation:0.9 brightness:0.8 alpha:0.99]
#define kSnowColor_ORANGE_DARK                                                 \
  [UIColor colorWithHue:0.05 saturation:0.9 brightness:0.8 alpha:0.99]
#define kSnowColor_YELLOW_DARK                                                 \
  [UIColor colorWithHue:0.15 saturation:0.85 brightness:0.8 alpha:0.99]
#define kSnowColor_GREEN_DARK                                                  \
  [UIColor colorWithHue:0.35 saturation:0.9 brightness:0.8 alpha:0.99]
#define kSnowColor_BLUE_DARK                                                   \
  [UIColor colorWithHue:0.55 saturation:0.9 brightness:0.85 alpha:0.99]

#define kSnowColor_BLACK                                                       \
  [UIColor colorWithHue:0.99 saturation:0.01 brightness:0.01 alpha:0.99]

@interface SnowTheme : NSObject

@property(nonatomic, strong) UIColor *primary;
@property(nonatomic, strong) UIColor *secondary;
@property(nonatomic, strong) UIColor *ternary;
@property(nonatomic, strong) UIColor *textColor;

@property(nonatomic, strong) UIColor *primaryLabel;
@property(nonatomic, strong) UIColor *secondaryLabel;
@property(nonatomic, strong) CAGradientLayer *gradient;
@property(nonatomic, strong) UIColor *gradientColor;

@property(nonatomic, strong) NSString *themeKey;

- (instancetype)initWithThemeName:(NSString *)theme;

@end
