//
//  SnowListManager.m
//  snow
//
//  Created by samuel maura on 5/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowListManager.h"

@implementation SnowListManager {
  NSDictionary *_listWithPendingTasks;

  NSDictionary *_completedTasks;
  NSDictionary *_deletedTasks;
  NSDictionary *_archivedTasks;
}

- (NSDictionary *)fetch {
  if (_listWithPendingTasks) {
    if ([[_listWithPendingTasks allKeys] count] > 0) {
        
        NSArray *unSortedList = [self fetchLists];
        
        unSortedList = [unSortedList sortedArrayUsingComparator:^NSComparisonResult(
                                                                              id obj1, id obj2) {
            NSTimeInterval l1 = [[(SnowList *)obj1 lastupdated] timeIntervalSince1970];
            NSTimeInterval l2 = [[(SnowList *)obj2 lastupdated] timeIntervalSince1970];
            if (l2 < l1) {
                return NSOrderedAscending;
            } else if (l2 > l1) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
            
        }];
        
        
        
        NSMutableDictionary *sortedDict = [NSMutableDictionary new];
        
        for (SnowList *i in unSortedList){
            [sortedDict setObject:i forKey:i.itemID];
        }
        
        return sortedDict;
      //return _listWithPendingTasks;
    }
  }
  return nil;
}




- (NSArray *)fetchSorted {
    if (_listWithPendingTasks) {
        if ([[_listWithPendingTasks allKeys] count] > 0) {
            
            NSArray *unSortedList = [self fetchLists];
            
            unSortedList = [unSortedList sortedArrayUsingComparator:^NSComparisonResult(
                                                                                        id obj1, id obj2) {
                NSTimeInterval l1 = [[(SnowList *)obj1 lastupdated] timeIntervalSince1970];
                NSTimeInterval l2 = [[(SnowList *)obj2 lastupdated] timeIntervalSince1970];
                if (l2 < l1) {
                    return NSOrderedAscending;
                } else if (l2 > l1) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
                
            }];
            
            
            return unSortedList;
        }
    }
    return nil;
}




- (NSArray *)fetchTasks {

  NSMutableArray *tasks = nil;

  if ((_listWithPendingTasks != nil) &&
      ([[_listWithPendingTasks allKeys] count] > 0)) {

    tasks = [NSMutableArray new];

    NSArray *keys = [_listWithPendingTasks allKeys];
    for (NSString *key in keys) {
      SnowList *listItem = [_listWithPendingTasks objectForKey:key];
      for (SnowTask *taskItem in listItem.tasklist) {
        [tasks addObject:taskItem];
      }
    }
  }

  if ((_archivedTasks != nil) && ([[_archivedTasks allKeys] count] > 0)) {

    if (tasks == nil) {
      tasks = [NSMutableArray new];
    }

    NSArray *keys = [_archivedTasks allKeys];
    for (NSString *key in keys) {
      SnowList *listItem = [_archivedTasks objectForKey:key];
      for (SnowTask *taskItem in listItem.tasklist) {
        [tasks addObject:taskItem];
      }
    }
  }

  if ((tasks) && ([tasks count] > 1)) {
    [tasks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      NSTimeInterval f1 = [[(SnowTask *)obj1 created] timeIntervalSince1970];
      NSTimeInterval f2 = [[(SnowTask *)obj2 created] timeIntervalSince1970];

      if (f1 < f2) {
        return NSOrderedDescending;
      } else if (f1 > f1) {
        return NSOrderedAscending;
      } else {
        return NSOrderedSame;
      }

    }];
  }

  return tasks;
}

- (NSArray *)fetchLists {
  NSMutableArray *list = nil;

  if ((_listWithPendingTasks != nil) &&
      ([[_listWithPendingTasks allKeys] count] > 0)) {
    list = [NSMutableArray new];
    NSArray *keys = [_listWithPendingTasks allKeys];
    for (NSString *key in keys) {
      [list addObject:[_listWithPendingTasks objectForKey:key]];
    }
  }

  return list;
}

- (NSArray *)fetchDeletedLists {
  NSMutableArray *list = nil;

  if ((_deletedTasks != nil) && ([[_deletedTasks allKeys] count] > 0)) {
    list = [NSMutableArray new];
    NSArray *keys = [_deletedTasks allKeys];
    for (NSString *key in keys) {
      [list addObject:[_deletedTasks objectForKey:key]];
    }
  }

  return list;
}
- (NSArray *)fetchCompletedLists {
  NSMutableArray *list = nil;

  if ((_completedTasks != nil) && ([[_completedTasks allKeys] count] > 0)) {
    list = [NSMutableArray new];
    NSArray *keys = [_completedTasks allKeys];
    for (NSString *key in keys) {
      [list addObject:[_completedTasks objectForKey:key]];
    }
  }

  return list;
}
- (NSArray *)fetchArchivedLists {
  NSMutableArray *list = nil;

  if ((_archivedTasks != nil) && ([[_archivedTasks allKeys] count] > 0)) {
    list = [NSMutableArray new];
    NSArray *keys = [_archivedTasks allKeys];
    for (NSString *key in keys) {
      [list addObject:[_archivedTasks objectForKey:key]];
    }
  }

  return list;
}

- (void)refreshForList:(SnowList *)list {
  _listWithPendingTasks =
      [[SnowDataManager sharedInstance] fetchTaskForList:list];

  _listWithPendingTasksCount = [[_listWithPendingTasks allKeys] count];

  [[SnowDataManager sharedInstance]
      fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {
        _allLists = lists;

      }];
}

- (void)refresh {
  _listWithPendingTasks =
      [[SnowDataManager sharedInstance] fetchTaskForList:nil];

  _listWithPendingTasksCount = [[_listWithPendingTasks allKeys] count];

  [[SnowDataManager sharedInstance]
      fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {
        _allLists = lists;

      }];
}


- (void)refreshLow {
    _listWithPendingTasks =
    [[SnowDataManager sharedInstance] fetchTaskForList:nil withPriority:[NSNumber numberWithInt:0]];
    
    _listWithPendingTasksCount = [[_listWithPendingTasks allKeys] count];
    
    [[SnowDataManager sharedInstance]
     fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {
         _allLists = lists;
         
     }];
}


- (void)refreshMedium {
    _listWithPendingTasks =
    [[SnowDataManager sharedInstance] fetchTaskForList:nil withPriority:[NSNumber numberWithInt:1]];
    
    _listWithPendingTasksCount = [[_listWithPendingTasks allKeys] count];
    
    [[SnowDataManager sharedInstance]
     fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {
         _allLists = lists;
         
     }];
}



- (void)refreshHigh {
    _listWithPendingTasks =
    [[SnowDataManager sharedInstance] fetchTaskForList:nil withPriority:[NSNumber numberWithInt:2]];
    
    _listWithPendingTasksCount = [[_listWithPendingTasks allKeys] count];
    
    [[SnowDataManager sharedInstance]
     fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {
         _allLists = lists;
         
     }];
}




- (void)refreshCompleted {
  _completedTasks =
      [[SnowDataManager sharedInstance] fetchCompletedTaskForList:nil];
}

- (void)refreshDeleted {
  _deletedTasks =
      [[SnowDataManager sharedInstance] fetchDeletedTaskForList:nil];
}

- (void)refreshArchived {
  _archivedTasks =
      [[SnowDataManager sharedInstance] fetchArchivedTaskForList:nil];
}

- (SnowList *)recentList {
  NSArray *listArray = [self fetchLists];
    if (listArray  == nil){
        listArray = _allLists;
    }
  listArray = [listArray sortedArrayUsingComparator:^NSComparisonResult(
                                                        id obj1, id obj2) {
    NSTimeInterval l1 = [[(SnowList *)obj1 lastupdated] timeIntervalSince1970];
    NSTimeInterval l2 = [[(SnowList *)obj2 lastupdated] timeIntervalSince1970];
    if (l2 < l1) {
      return NSOrderedAscending;
    } else if (l2 > l1) {
      return NSOrderedDescending;
    } else {
      return NSOrderedSame;
    }

  }];

  return [listArray firstObject];
}

- (SnowList *)defaultList {
  NSArray *listArray = nil;
    // Try list with pending tasks
  if (([self fetchLists] != nil) && ([[self fetchLists] count] > 0)) {
    listArray = [self fetchLists];
    return [self recentList];
  } else {
      // All lists
    listArray = _allLists;
  }
  // Try default list if any
  for (SnowList *item in listArray) {
    if ([item.itemID isEqualToString:@"default"]) {
      return item;
    }
  }

  return [self recentList];
}

- (SnowList *)getListWithID:(NSString *)listId {
  SnowList *found = nil;

  for (SnowList *item in _allLists) {
    if ([item.itemID isEqualToString:listId]) {
      return item;
    }
  }

  return found;
}

@end
