//
//  SnowSound.h
//  snow
//
//  Created by samuel maura on 6/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <Foundation/Foundation.h>

// Long
extern NSString *const SNOW_ALERT_LONG_RAILS;
extern NSString *const SNOW_ALERT_LONG_POLICE_BRIT;
extern NSString *const SNOW_ALERT_LONG_SCHOOL_ALARM;

// Short
extern NSString *const SNOW_ALERT_SHORT_PHONE_VIBRATE;
extern NSString *const SNOW_ALERT_SHORT_INDUSTRIAL_ALARM;

/*
extern NSDictionary *const soundDisplayName;
*/

@interface SnowSound : NSObject

@property(nonatomic, strong) NSString *soundName;
//@property(nonatomic, strong) NSDictionary *soundDisplayName;

- (instancetype)initWithSoundName:(NSString *)name;

+(NSString *)nameForKey:(NSString *)key;

@end
