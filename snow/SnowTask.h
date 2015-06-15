//
//  SnowTask.h
//  snow
//
//  Created by samuel maura on 3/19/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowTask : NSObject

@property(nonatomic, copy) NSString *itemID;
@property(nonatomic, copy) NSString *listID;
@property(nonatomic, copy) NSString *title;

@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSNumber *priority; // 0=LOW 1=MED 2=HIGH

@property(nonatomic, strong) NSDate *created;
@property(nonatomic, copy) NSString *repeat; // none,daily,weekly,monthly,yearly
@property(nonatomic, strong) NSDate *reminder;

@property(nonatomic, assign) BOOL deleted;
@property(nonatomic, assign) BOOL completed;
@property(nonatomic, strong) NSDate *completionDate;
@property(nonatomic, strong) NSDate *lastupdated;

@end
