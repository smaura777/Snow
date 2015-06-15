//
//  SnowButtonTypeA2.m
//  snow
//
//  Created by samuel maura on 5/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowButtonTypeA2.h"
#import "SnowAppearanceManager.h"

@implementation SnowButtonTypeA2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)customizeForType:(NSUInteger)type {

  UIColor *btBorderColor =
      [UIColor colorWithHue:0.5 saturation:1 brightness:0.3 alpha:.7];

  UIColor *btTextColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  // [UIColor colorWithHue:0.5 saturation:1 brightness:1 alpha:1];

 // UIColor *btTextColorSelected =
   //   [UIColor colorWithHue:1 saturation:1 brightness:1 alpha:1];

 // UIColor *btBackgroundNormal =
   //   [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:1];

  // UIFont *bf = [UIFont fontWithName:@"AvenirNextCondensed-UltraLight"
  // size:36];
  UIFont *bf = [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:24];

  CGFloat borderWidth = 0;

  switch (type) {
  case 0: {

    self.titleLabel.font = bf;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = btBorderColor.CGColor;

    [self setTitleColor:btTextColor forState:UIControlStateNormal];
    // [self setTitleColor:btTextColorSelected
    // forState:UIControlStateHighlighted];

    // [self setTintColor: [UIColor redColor]];
    /*
        [self setBackgroundImage:[UIImage imageWithColor:btTextColor]
                        forState:UIControlStateHighlighted];

        [self setBackgroundImage:[UIImage imageWithColor:btBackgroundNormal]
                        forState:UIControlStateNormal];
     */

    [self setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                    forState:UIControlStateNormal];

  } break;

  default:
    break;
  }
}

@end
