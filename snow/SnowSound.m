//
//  SnowSound.m
//  snow
//
//  Created by samuel maura on 6/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowSound.h"

// Long
NSString *const SNOW_ALERT_LONG_RAILS = @"rails_30.caf";
NSString *const SNOW_ALERT_LONG_POLICE_BRIT = @"police_brit_siren.caf";
NSString *const SNOW_ALERT_LONG_SCHOOL_ALARM = @"school_alarm.caf";

// Short
NSString *const SNOW_ALERT_SHORT_PHONE_VIBRATE = @"phone_vibrate.caf";
NSString *const SNOW_ALERT_SHORT_INDUSTRIAL_ALARM = @"industrial_alarm.caf";

@implementation SnowSound

+ (NSString *)nameForKey:(NSString *)key {

  NSDictionary *soundDisplayName = @{
    SNOW_ALERT_LONG_RAILS : @"Train",
    SNOW_ALERT_LONG_POLICE_BRIT : @"London",
    SNOW_ALERT_LONG_SCHOOL_ALARM : @"School",
    SNOW_ALERT_SHORT_INDUSTRIAL_ALARM : @"Industrial",
    SNOW_ALERT_SHORT_PHONE_VIBRATE : @"Vibrate"
  };
  NSString *val = [[soundDisplayName objectForKey:key] copy];
  return val;
}

- (instancetype)init {
  return [self initWithSoundName:nil];
}

- (instancetype)initWithSoundName:(NSString *)name {
  self = [super init];

  if (self) {
    _soundName = [self setupWithSoundName:name];
  }

  return self;
}

- (NSString *)setupWithSoundName:(NSString *)name {

  NSString *filename;

  if ([name isEqualToString:SNOW_ALERT_LONG_RAILS]) {
    filename = SNOW_ALERT_LONG_RAILS;
  } else if ([name isEqualToString:SNOW_ALERT_LONG_POLICE_BRIT]) {
    filename = SNOW_ALERT_LONG_POLICE_BRIT;
  } else if ([name isEqualToString:SNOW_ALERT_LONG_SCHOOL_ALARM]) {
    filename = SNOW_ALERT_LONG_SCHOOL_ALARM;
  } else if ([name isEqualToString:SNOW_ALERT_SHORT_PHONE_VIBRATE]) {
    filename = SNOW_ALERT_SHORT_PHONE_VIBRATE;
  } else if ([name isEqualToString:SNOW_ALERT_SHORT_INDUSTRIAL_ALARM]) {
    filename = SNOW_ALERT_SHORT_INDUSTRIAL_ALARM;
  } else {
    filename = SNOW_ALERT_SHORT_INDUSTRIAL_ALARM;
  }

  return filename;
}

@end
