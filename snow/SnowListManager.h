//
//  SnowListManager.h
//  snow
//
//  Created by samuel maura on 5/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowDataManager.h"

@interface SnowListManager : NSObject

@property(nonatomic, assign) NSInteger listWithPendingTasksCount;

@property(nonatomic, strong) NSArray *allLists;

- (NSArray *)fetchSorted;

- (NSDictionary *)fetch;

- (NSArray *)fetchLists;
- (NSArray *)fetchTasks; // array of SnowTask objects
- (NSArray *)fetchDeletedLists;
- (NSArray *)fetchCompletedLists;
- (NSArray *)fetchArchivedLists;

- (void)refreshForList:(SnowList *)list;

- (void)refresh;
- (void)refreshCompleted;
- (void)refreshDeleted;
- (void)refreshArchived;

- (void)refreshLow;
- (void)refreshMedium;
- (void)refreshHigh;

- (SnowList *)defaultList;
- (SnowList *)recentList;

- (SnowList *)getListWithID:(NSString *)listId;

@end
