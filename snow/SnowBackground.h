//
//  SnowBackground.h
//  snow
//
//  Created by samuel maura on 4/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSnow_bk001 @"desert_valley_daylight.jpg"
#define kSnow_bk002 @"eiffel_bridge.jpg"
#define kSnow_bk003 @"eiffel_tower_dawn.jpg"
#define kSnow_bk004 @"london_skyline_dawn.jpg"
#define kSnow_bk005 @"london_skyline_daylight.jpg"
#define kSnow_bk006 @"london_skyline_sunset.jpg"
#define kSnow_bk007 @"monkey_fuscata.jpg"
#define kSnow_bk008 @"nyc_skyline_night.jpg"
#define kSnow_bk009 @"snow_monkeys.jpg"
#define kSnow_bk010 @"tajmahal_daylight.jpg"
#define kSnow_bk011 @"etower1.jpg"

@interface SnowBackground : NSObject

@property(nonatomic, strong) UIImage *background;
@property(nonatomic, strong) NSString *backgroundKey;

- (instancetype)initWithBackgroundName:(NSString *)bk;

@end
