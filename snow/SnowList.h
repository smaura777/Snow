//
//  SnowList.h
//  snow
//
//  Created by samuel maura on 3/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnowList : NSObject

@property(nonatomic, copy) NSString *itemID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSDate *created;
@property(nonatomic, strong) NSDate *lastupdated;
@property(nonatomic, strong) NSNumber *taskcount;
@property(nonatomic, assign) BOOL deleted;

@property(nonatomic, strong) NSMutableArray *tasklist;

@end
