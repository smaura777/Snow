//
//  SnowBackground.m
//  snow
//
//  Created by samuel maura on 4/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowBackground.h"

@implementation SnowBackground

- (instancetype)initWithBackgroundName:(NSString *)bk {
  if (self = [super init]) {
    [self setupBackgroundForName:bk];
  }
  return self;
}

- (instancetype)init {
  return [self initWithBackgroundName:nil];
}

/**
 @"desert",
 @"eiffel & bridge",
 @"eiffel at dawn",
 @"london skyline dawn",
 @"london skyline daylight",
 @"london skyline sunset",
 @"monkey fucata",
 @"New York night sky",


 @"snow monkeys",
 @"taj mahal",
 @"eiffel romantic"
 **/

- (void)setupBackgroundForName:(NSString *)key {
  _backgroundKey = key;

  if ([key isEqualToString:@"desert"]) {
    _background = [UIImage imageNamed:kSnow_bk001];
  } else if ([key isEqualToString:@"eiffel & bridge"]) {
    _background = [UIImage imageNamed:kSnow_bk002];
  } else if ([key isEqualToString:@"eiffel at dawn"]) {
    _background = [UIImage imageNamed:kSnow_bk003];
  } else if ([key isEqualToString:@"london skyline dawn"]) {
    _background = [UIImage imageNamed:kSnow_bk004];
  } else if ([key isEqualToString:@"london skyline daylight"]) {
    _background = [UIImage imageNamed:kSnow_bk005];
  } else if ([key isEqualToString:@"london skyline sunset"]) {
    _background = [UIImage imageNamed:kSnow_bk006];
  } else if ([key isEqualToString:@"monkey fucata"]) {
    _background = [UIImage imageNamed:kSnow_bk007];
  } else if ([key isEqualToString:@"New York night sky"]) {
    _background = [UIImage imageNamed:kSnow_bk008];
  } else if ([key isEqualToString:@"snow monkeys"]) {
    _background = [UIImage imageNamed:kSnow_bk009];
  } else if ([key isEqualToString:@"taj mahal"]) {
    _background = [UIImage imageNamed:kSnow_bk010];
  } else if ([key isEqualToString:@"eiffel romantic"]) {
    _background = [UIImage imageNamed:kSnow_bk011];
  } else {
    _background = [UIImage imageNamed:kSnow_bk005];
    _backgroundKey = @"london skyline daylight";
  }
}

@end
