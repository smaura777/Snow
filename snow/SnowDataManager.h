//
//  SnowDataManager.h
//  snow
//
//  Created by samuel maura on 3/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "SnowList.h"
#import "snowTask.h"
#import "SnowTheme.h"
#import "SnowBackground.h"
#import "SnowTimer.h"
#import "SnowSound.h"

@interface SnowDataManager : NSObject
@property NSArray *cachedList;
@property NSArray *cachedTask;

@property(nonatomic, copy) NSString * (^bsdf)(void);

+ (instancetype)sharedInstance;

#pragma mark -  // List

- (BOOL)saveList:(SnowList *)list;

- (void)saveList:(SnowList *)list
    WithCompletionHandler:(void (^)(NSError *error, NSArray *list))handler;

- (void)removeList:(SnowList *)list
    WithCompletionHandler:(void (^)(NSError *error, NSArray *lists))handler;

- (BOOL)updateList:(SnowList *)list;

- (void)fetchListByID:(NSString *)listId
WithCompletionHandler:(void (^)(NSError *error, NSArray *lists))handler;

- (void)fetchlist; // Double duty

- (void)fetchListWithCompletionHandler:(void (^)(NSError *error,
                                                 NSArray *lists))handler;

- (void)fetchListContainingTasksWithCompletionHandler:
    (void (^)(NSError *error, NSArray *lists))handler;

#pragma mark -  // Task

- (void)saveTask:(SnowTask *)task
    WithCompletionHandler:
        (void (^)(NSError *error, NSDictionary *listSet))handler;

- (void)removeTask:(SnowTask *)task
    WithCompletionHandler:(void (^)(NSError *error, NSDictionary *task))handler;

- (void)removeAllArchivedTasksWithCompletionHandler:
    (void (^)(NSError *error, NSDictionary *task))handler;

- (void)updateTask:(SnowTask *)task
    WithCompletionHandler:(void (^)(NSError *error, NSDictionary *task))handler;

#pragma mark -  // Timer

- (void)saveTimer:(SnowTimer *)timer;
- (void)removeSavedTimer:(SnowTimer *)tm;
- (SnowTimer *)fetchSavedTimerForKey:(NSString *)key;
- (void)updatedTimer:(SnowTimer *)timer;

#pragma mark -  // Fetchers
- (NSDictionary *)fetchTaskForList:(SnowList *)list;
- (NSDictionary *)fetchCompletedTaskForList:(SnowList *)list;
- (NSDictionary *)fetchDeletedTaskForList:(SnowList *)list;
- (NSDictionary *)fetchArchivedTaskForList:(SnowList *)list;
- (NSDictionary *)fetchTaskForList:(SnowList *)list
                      withPriority:(NSNumber *)priority;

#pragma mark -  // Color themes
- (void)updateDefaultTheme:(SnowTheme *)theme;
- (SnowTheme *)fetchDefaultTheme;

#pragma mark - // Image background
- (void)updateDefaultBackground:(SnowBackground *)background;
- (SnowBackground *)fetchDefaultBackground;

#pragma mark -  Sound alert preferences
-(void)updateDefaultSound:(SnowSound *)sound;
-(SnowSound *)fetchDefaultSound;




@end
