//
//  BackgroundLayer.m
//  snow
//
//  Created by samuel maura on 4/22/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer
+ (CAGradientLayer *)greenGradient {
  UIColor *colorOne =
      [UIColor colorWithHue:0.48 saturation:0.3 brightness:0.9 alpha:0.7];
  UIColor *colorTwo =
      [UIColor colorWithHue:0.48 saturation:0.3 brightness:0.88 alpha:0.7];

  NSArray *colors = @[ (id)colorOne.CGColor, (id)colorTwo.CGColor ];

  NSNumber *stopOne = [NSNumber numberWithFloat:0.5];
  NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];

  NSArray *locations = @[ stopOne, stopTwo ];

  CAGradientLayer *greenGradient = [CAGradientLayer layer];
  greenGradient.colors = colors;
  greenGradient.locations = locations;

  return greenGradient;
}

@end
