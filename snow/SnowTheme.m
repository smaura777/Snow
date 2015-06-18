//
//  SnowTheme.m
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTheme.h"

@implementation SnowTheme

- (instancetype)initWithThemeName:(NSString *)theme {
  if (self = [super init]) {
    // Configure
    [self setupThemeComponentsFor:[theme lowercaseString]];
  }

  return self;
}

- (instancetype)init {
  return [self initWithThemeName:nil];
}

- (void)setupThemeComponentsFor:(NSString *)theme {
  _themeKey = theme;

  if ([theme isEqualToString:@"azure"]) {
    [self azure];
  } else if ([theme isEqualToString:@"fog"]) {
    [self grass];
  } else if ([theme isEqualToString:@"neon"]) {
    [self neon];
  } else if ([theme isEqualToString:@"sunny"]) {
    [self sunny];
  } else if ([theme isEqualToString:@"orange"]) {
    [self orange];
  } else if ([theme isEqualToString:@"light"]) {
    [self light];
  } else {
    // default
    [self azure];
    _themeKey = @"azure";
  }
}

- (void)azure {
  // NSLog(@"Theme selected azure ");
  _primary = kSnowColor_BLUE;
  _secondary = kSnowColor_BLUE_DARK;
  _textColor = kSnowColor_WHITE_OPAQUE;

  _textColor = kSnowColor_WHITE_OPAQUE;

  _primary = [UIColor colorWithRed:.1 green:.7 blue:.99 alpha:1];

  _secondary = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  _ternary = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
  _primaryLabel = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  _secondaryLabel = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
}

- (void)grass {
  /*
_primary = kSnowColor_GREEN;
_secondary = kSnowColor_GREEN_DARK;
*/

  _textColor = kSnowColor_WHITE_OPAQUE;
  _primary = [UIColor colorWithRed:.231 green:.266 blue:.294 alpha:1];
  _secondary = [UIColor colorWithRed:.698 green:.745 blue:.709 alpha:1];

  //_ternary = [UIColor colorWithRed:.70 green:.95 blue:.90 alpha:1];
  //[UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1];
  _ternary = [UIColor colorWithRed:.87 green:.87 blue:.87 alpha:1];

  //  _gradient = [CAGradientLayer layer];
  //
  //  _gradientColor =
  //      [UIColor colorWithHue:0.48 saturation:0.2 brightness:0.9 alpha:1.0];
  //
  //  _gradient.colors =
  //      [NSArray arrayWithObjects:(id)[UIColor colorWithHue:0.48
  //                                               saturation:0.5
  //                                               brightness:0.7
  //                                                    alpha:1.0].CGColor,
  //                                (id)_primary.CGColor, nil];
  //
  //  _gradient.startPoint = CGPointMake(0.0, 0.50);
  //  _gradient.endPoint = CGPointMake(1.0, 0.0);
  //  _gradient.locations =
  //      @[ [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.5] ];

  _primaryLabel = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _secondaryLabel = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
}

- (void)neon {
  // NSLog(@"Theme selected neon ");
  _primary = kSnowColor_RED;
  _secondary = kSnowColor_RED_DARK;
  _textColor = kSnowColor_WHITE_OPAQUE;

  _textColor = kSnowColor_WHITE_OPAQUE;

  _primary = [UIColor colorWithRed:.439 green:.16 blue:.368 alpha:1];
  _secondary = [UIColor colorWithRed:.741 green:.2 blue:.64 alpha:1];
  _secondary = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  //_ternary = [UIColor colorWithRed:.70 green:.95 blue:.90 alpha:1];
  _ternary = [UIColor colorWithRed:.87 green:.87 blue:.87 alpha:1];

  _primaryLabel = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _secondaryLabel = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
}

- (void)sunny {
  // NSLog(@"Theme selected sunny ");
  //_primary = kSnowColor_ORANGE;
  //_secondary = kSnowColor_ORANGE_DARK;
  // _textColor = kSnowColor_WHITE_OPAQUE;

  // _textColor = kSnowColor_WHITE_OPAQUE;

  _textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _primaryLabel = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _secondaryLabel = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];

  // Banana yellow
  _primary = [UIColor colorWithRed:.1 green:.9 blue:.6 alpha:1];

  _secondary = [UIColor whiteColor]; // [UIColor colorWithRed:.32 green:.31
                                     // blue:.11 alpha:1];

  //  _secondary =[UIColor colorWithRed:.1 green:1 blue:.7 alpha:1];
  //_textColor = _secondary;

  //_secondary = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  //_ternary = [UIColor colorWithRed:.98 green:.94 blue:.74 alpha:1];

  //_ternary = [UIColor colorWithRed:.87 green:.87 blue:.87 alpha:1];

  //_ternary = [UIColor colorWithRed:.05 green:.05 blue:.05 alpha:1];

  //_ternary = [UIColor colorWithRed:.1 green:.6 blue:.3 alpha:1];
  _ternary = [UIColor colorWithRed:.15 green:.20 blue:.15 alpha:1];
}

- (void)light {
  _primary = kSnowColor_WHITE;
  _secondary = kSnowColor_RED_DARK;
  _textColor = kSnowColor_RED;

  _textColor = kSnowColor_WHITE_OPAQUE;
  _primary = [UIColor colorWithRed:.18 green:.83 blue:.78 alpha:1];
  _secondary = [UIColor colorWithRed:0 green:.54 blue:.54 alpha:1];
  _secondary = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  //_ternary = [UIColor colorWithRed:.70 green:.95 blue:.90 alpha:1];
  _ternary = [UIColor colorWithRed:.87 green:.87 blue:.87 alpha:1];

  _ternary = [UIColor colorWithRed:0 green:.13 blue:.18 alpha:1];

  _primaryLabel = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _secondaryLabel = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
}

- (void)orange {
  _textColor = kSnowColor_WHITE_OPAQUE;

  _primary = [UIColor colorWithRed:.99 green:.25 blue:.25 alpha:1];

  _secondary = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _ternary = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];

  _primaryLabel = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];

  _secondaryLabel = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1];
}

@end
