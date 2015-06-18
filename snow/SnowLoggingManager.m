//
//  SnowLoggingManager.m
//  snow
//
//  Created by samuel maura on 6/17/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowLoggingManager.h"

@implementation SnowLoggingManager

+ (instancetype)sharedInstance {
  static SnowLoggingManager *loggingManager = nil;
  static dispatch_once_t token;

  if (loggingManager == nil) {
    dispatch_once(&token, ^{
      loggingManager = [[SnowLoggingManager alloc] init];
    });
  }

  return loggingManager;
}

- (instancetype)init {
  self = [super init];
  return self;
}

- (void)SnowLog:(NSString *)format, ... {

  /*
   NSMutableString *newContentString = [NSMutableString string];
   va_list args;
   va_start(args, format);
   for (NSString *arg = format; arg != nil; arg = va_arg(args, NSString *)) {
     [newContentString appendString:arg];
   }
   va_end(args);


    */

  if (_mode == 0) {
    return;
  }

  va_list args;
  va_start(args, format);
  NSString *contents = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);

  NSLog(contents, nil);
}

@end
