//
//  SnowDataManager.m
//  snow
//
//  Created by samuel maura on 3/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowDataManager.h"

#define kSnowDocumentURL                                                       \
  [[[NSFileManager defaultManager]                                             \
      URLsForDirectory:NSDocumentDirectory                                     \
             inDomains:NSUserDomainMask] firstObject]
#define kSnowAppCacheURL                                                       \
  [[[NSFileManager defaultManager]                                             \
      URLsForDirectory:NSCachesDirectory                                       \
             inDomains:NSUserDomainMask] firstObject]
#define kSnowAppSupportURL                                                     \
  [[[NSFileManager defaultManager]                                             \
      URLsForDirectory:NSApplicationSupportDirectory                           \
             inDomains:NSUserDomainMask] firstObject]
#define kSnowAllAppsURL                                                        \
  [[[NSFileManager defaultManager]                                             \
      URLsForDirectory:NSAllApplicationsDirectory                              \
             inDomains:NSUserDomainMask] firstObject]

#define kSnowDBName @"snowdb-dev-v0.sql"

#define kSnowDataStore_createdb                                                \
  @"CREATE TABLE datastore_version (db_version REAL NOT NULL );\
CREATE TABLE datastore_info (table_name varchar(140) UNIQUE NOT NULL, \
version_number REAL NOT NULL );\
\
CREATE TABLE snowlist (id varchar(40) not null PRIMARY KEY, title varchar(140) not null, \
created NUMERIC not null default 0,type NUMERIC not null default 0 , \
deleted NUMERIC  not null default 0,lastupdated NUMERIC NOT NULL  default 0,\
task_count INTEGER default 0);\
\
CREATE TABLE snowtask (id varchar(40) not null PRIMARY KEY,listID varchar(40) not null, \
title varchar(200) not null,created NUMERIC not null default 0,\
type NUMERIC not null default 0 ,priority NUMERIC not null default 0 ,\
reminder NUMERIC not null default 0,repeat varchar(25) not null default 'none',\
deleted NUMERIC not null default 0, completed NUMERIC not null default 0 ,\
completionDate NUMERIC not null default 0,lastupdated NUMERIC not null default 0 );\
\
CREATE TABLE snowtimer (id varchar(40) not null PRIMARY KEY, \
title varchar(25) UNIQUE NOT NULL, expiration NUMERIC not null, \
state NUMERIC not null default 0,lastupdated NUMERIC not null default 0);\
\
CREATE TABLE snowlist_preferences  (domain varchar(80) not null,\
key_name varchar(40) not null,key_val varchar(100) not null  );\
\
INSERT INTO datastore_info (table_name,version_number) VALUES \
('snowtask',0.1),('snowlist',0.1),('snowlist_preferences',0.1); \
INSERT INTO datastore_version (db_version) VALUES(1.0);\
INSERT INTO snowlist (id,title,created,type,deleted) \
VALUES ('shopping-list-01','Shopping',1431706400,0,0),\
('mustread-list-02','Must Read Books',1431706401,0,0),\
('grocery-list-03','Groceries',1431706402,0,0),\
('default','To Dos',1431706402,0,0);\
\
CREATE TRIGGER task_addition INSERT ON snowtask  \
BEGIN \
  UPDATE snowlist set task_count = (task_count +1) ,lastupdated = new.created \
  WHERE new.listID = id ; \
 END; \
\
CREATE TRIGGER task_update UPDATE ON snowtask  \
BEGIN \
UPDATE snowlist set lastupdated = new.lastupdated \
WHERE new.listID = id ; \
END; \
\
CREATE TRIGGER task_deletion DELETE ON snowtask  \
BEGIN \
UPDATE snowlist set task_count = (task_count -1)  \
WHERE old.listID = id ; \
END; \
"

#define kSnowDataStore_create_snowlist                                         \
  @"CREATE TABLE snowlist (id varchar(40) not null, title varchar(140) not null, \
created NUMERIC not null default 0,type NUMERIC not null default 0 , \
deleted NUMERIC  not null default 0);"

#define kSnowDataStore_create_snowprefs                                        \
  @"CREATE TABLE snowlist_preferences  (domain varchar(80) not null,\
key_name varchar(40) not null,key_val varchar(100) not null  );"

#define kSnowDataStore_create_snowprefs2                                       \
  @"CREATE TABLE snowlist_preferences2  (domain varchar(80) not null,\
key_name varchar(40) not null,key_val varchar(100) not null  );"

#define kSnowDataStore_create_snowtask                                         \
  @"CREATE TABLE snowtask (id varchar(40) not null,listID varchar(40) not null, \
title varchar(200) not null,created NUMERIC not null default 0,\
type NUMERIC not null default 0 ,priority NUMERIC not null default 0 ,\
reminder NUMERIC not null default 0,repeat varchar(25) not null default 'none',\
deleted NUMERIC not null default 0, completed NUMERIC not null default 0 ,\
completionDate NUMERIC not null default 0 );"

#define kSnowDataStore_update_snowlist                                         \
  @"CREATE TABLE snowlist2 (id varchar(40) not null, title varchar(140) not null, \
created NUMERIC not null default 0,type NUMERIC not null default 0 , \
deleted NUMERIC  not null default 0,lastupdated NUMERIC NOT NULL  default 0,\
task_count INTEGER default 0 );\
INSERT INTO snowlist2 (id,title,created,type,deleted) \
SELECT id,title,created,type,deleted FROM snowlist;\
DROP TABLE snowlist;\
ALTER TABLE snowlist2 RENAME TO snowlist;\
UPDATE  datastore_info SET version_number = 0.2 \
WHERE table_name = 'snowlist';"

// for Priority column ...
/*
#define kSnowDataStore_update_snowtask \
  @"CREATE TABLE snowtask2 (id varchar(40) not null,listID varchar(40) not null,
\
title varchar(200) not null,created NUMERIC not null default 0,\
type NUMERIC not null default 0 ,priority NUMERIC not null default 0 ,\
reminder NUMERIC not null default 0,repeat varchar(25) not null default 'none',\
deleted NUMERIC not null default 0, completed NUMERIC not null default 0 ,\
completionDate NUMERIC not null default 0 );\
INSERT INTO snowtask2 (id,listID,title,created,type,\
reminder,repeat,deleted, completed,completionDate)\
SELECT  id,listID,title,created,type,\
reminder,repeat,deleted, completed,completionDate FROM snowtask;\
DROP TABLE snowtask;\
ALTER TABLE snowtask2 RENAME TO snowtask;\
UPDATE  datastore_info SET version_number = 0.1 \
WHERE table_name = 'snowtask';"
*/

#define kSnowDataStore_update_snowtask                                         \
  @"CREATE TRIGGER task_addition INSERT ON snowtask  \
BEGIN \
UPDATE snowlist set task_count = (task_count +1) ,lastupdated = new.created \
WHERE new.listID = id ; \
END; \
UPDATE  datastore_info SET version_number = 0.2 \
WHERE table_name = 'snowtask';\
"

#define kSnow_additions                                                        \
  @"CREATE table samina (user varchar(20) not null,pass varchar(10)  ); \
INSERT INTO samina (user,pass) VALUES ('paul','23' ),('peter','dsf3');\
UPDATE datastore_version set db_version = 2.0;\
"

const double kSnowDataStore_version = 1.0;

@interface SnowDataManager () {
  dispatch_queue_t _dbq;
}

@property FMDatabaseQueue *queue;

@property NSURL *databaseURL;

@property FMDatabase *fmd;

- (void)setupDB;
- (void)sortList;

@end

@implementation SnowDataManager {
  NSDictionary *_dataStore;
  NSDictionary *_tableCreateStmts;
  NSDictionary *_tableUpdateStmts;

  NSMutableArray *_createTasks;
  NSMutableArray *_updateTasks;

  // = [NSNumber numberWithDouble:2.0];
}

+ (instancetype)sharedInstance {
  static SnowDataManager *snow = nil;
  static dispatch_once_t token;

  if (snow == nil) {
    dispatch_once(&token, ^{
      snow = [[SnowDataManager alloc] init];
    });
  }

  return snow;
}

// ===================================================================

#pragma mark - DB Management methods

- (instancetype)init {
  if (self = [super init]) {
    _databaseURL = [kSnowDocumentURL URLByAppendingPathComponent:kSnowDBName];

    _dbq = dispatch_queue_create("com.plateanmug.fmdb", NULL);
    _cachedList = [NSArray new];

    _dataStore = @{
      @"snowlist" : @"0.1",
      @"snowtask" : @"0.1",
      @"snowlist_preferences" : @"0.1"
    };

    _tableCreateStmts = @{
      @"snowlist" : kSnowDataStore_create_snowlist,
      @"snowtask" : kSnowDataStore_create_snowtask,
      @"snowlist_preferences" : kSnowDataStore_create_snowprefs
    };

    _tableUpdateStmts = @{
      @"snowlist" : kSnowDataStore_update_snowlist,
      @"snowtask" : kSnowDataStore_update_snowtask
    };

    _createTasks = [NSMutableArray new];
    _updateTasks = [NSMutableArray new];

    //[self setupDB];
    [self createDB];
  }
  return self;
}

- (void)setupDB {
  if ([[NSFileManager defaultManager] fileExistsAtPath:[_databaseURL path]]) {
    _queue = [FMDatabaseQueue databaseQueueWithPath:[_databaseURL path]];
    return;
  } else {
    _queue = [FMDatabaseQueue databaseQueueWithPath:[_databaseURL path]];
  }

  [_queue inDatabase:^(FMDatabase *db) {

    NSString *sql1 = nil;
    NSString *sql2 = nil;
    NSString *sql3 = nil;

    NSString *sql4 = nil;

    sql1 = @"CREATE TABLE snowlist (id varchar(40) not null, title "
        @"varchar(140) not null,"
         " created NUMERIC not null default 0,"
         " type NUMERIC not null default 0 , deleted NUMERIC  not null default "
         "0 );";

    sql2 = @"CREATE INDEX snowlist_index on snowlist (title);";

    sql3 = @"CREATE TABLE snowtask (id varchar(40) not null,"
            "listID varchar(40) not null, title varchar(200) not null,"
            " created NUMERIC not null default 0,"
            " type NUMERIC not null default 0 ,"
            " priority NUMERIC not null default 0 ,"
            " reminder NUMERIC not null default 0,"
            " repeat varchar(25) not null default 'none' ,"
            "deleted NUMERIC not null default 0, completed NUMERIC not null "
            "default 0 , completionDate NUMERIC not null default 0 );";

    sql4 = @"CREATE TABLE snowlist_preferences  (domain varchar(80) not null "
        @",key_name varchar(40) not null,"
        @" key_val varchar(100) not null  );";

    BOOL st1 = [db executeUpdate:sql1];
    if (st1 == NO) {
      // NSLog(@"Last Error: %@", [db lastErrorMessage]);
    }

    BOOL st2 = [db executeUpdate:sql2];
    if (st2 == NO) {
      // NSLog(@"Last Error: %@", [db lastErrorMessage]);
    }

    BOOL st3 = [db executeUpdate:sql3];
    if (st3 == NO) {
      // NSLog(@"Last Error: %@", [db lastErrorMessage]);
    }

    BOOL st4 = [db executeUpdate:sql4];
    if (st4 == NO) {
      // NSLog(@"Last Error: %@", [db lastErrorMessage]);
    }

  }];
}

- (void)createDB {
  if ([[NSFileManager defaultManager] fileExistsAtPath:[_databaseURL path]]) {
    _queue = [FMDatabaseQueue databaseQueueWithPath:[_databaseURL path]];
    [self checkDB];
    [self runCreateTasks];
    [self runUpdateTasks];
    [self checkDBVersion];
    [self dumpDatabase];
  } else {
    // NSLog(@"CREATE STMT ===========  %@\n", kSnowDataStore_createdb);

    _queue = [FMDatabaseQueue databaseQueueWithPath:[_databaseURL path]];
    [_queue inDatabase:^(FMDatabase *db) {
      [db beginTransaction];
      BOOL st = [db executeStatements:kSnowDataStore_createdb];

      if (st == NO) {
        [db rollback];
        // NSLog(@"Last Error: %@", [db lastErrorMessage]);
      } else {
        [db commit];
      }

    }];
  }
}

- (void)checkDB {
  // all tables
  NSArray *tableList = [_dataStore allKeys];

  [_queue inDatabase:^(FMDatabase *db) {

    FMResultSet *results = [db executeQuery:@"SELECT * FROM datastore_info  "];

    while ([results next]) {
      NSString *tableName = [results stringForColumn:@"table_name"];
      NSNumber *tableVersion = [NSNumber
          numberWithDouble:[results doubleForColumn:@"version_number"]];

      BOOL foundAMatch = NO;
      BOOL needUpdate = NO;

      for (NSString *tb in tableList) {
        if ([tb isEqualToString:tableName]) {
          foundAMatch = YES;
          if (![[_dataStore objectForKey:tb]
                  isEqualToString:[tableVersion stringValue]]) {
            needUpdate = YES;
          }
        }
      }

      if (foundAMatch == NO) {
        [_createTasks addObject:[_tableCreateStmts objectForKey:tableName]];
      } else {
        if (needUpdate == YES) {
          [_updateTasks addObject:[_tableUpdateStmts objectForKey:tableName]];
        }
      }
    }

  }];
}

- (void)checkDBVersion {
  __block BOOL needSchemaChange = NO;

  [_queue inDatabase:^(FMDatabase *db) {

    FMResultSet *results =
        [db executeQuery:@"SELECT * FROM datastore_version "];
    while ([results next]) {
      NSNumber *dbVersion =
          [NSNumber numberWithDouble:[results doubleForColumn:@"db_version"]];

      if ([dbVersion doubleValue] != kSnowDataStore_version) {
        needSchemaChange = YES;
      }
    }
  }];

  if (needSchemaChange == YES) {
    [_queue inDatabase:^(FMDatabase *db) {
      [db beginTransaction];
      BOOL ust = [db executeStatements:kSnow_additions];
      if (ust) {
        [db commit];
      } else {
        [db rollback];
      }
    }];
  }
}

- (void)runCreateTasks {
  for (NSString *dbStmt in _createTasks) {
    [_queue inDatabase:^(FMDatabase *db) {
      [db beginTransaction];
      BOOL cst = [db executeStatements:dbStmt];
      if (cst == NO) {
        [db rollback];
        // NSLog(@"lAST ERROR %@", [db lastError]);
      } else {
        [db commit];
      }

    }];
  }
}

- (void)runUpdateTasks {
  for (NSString *dbStmt in _updateTasks) {
    [_queue inDatabase:^(FMDatabase *db) {
      [db beginTransaction];
      BOOL ust = [db executeStatements:dbStmt];
      if (ust == NO) {
        [db rollback];
        // NSLog(@"lAST ERROR %@", [db lastError]);
      } else {
        [db commit];
      }

    }];
  }
}

- (void)dumpDatabase {
  NSString *dumpsql_list = @"SELECT * FROM snowlist ";
  NSString *dumpsql_task = @"SELECT * FROM snowtask ";
  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = [db executeQuery:dumpsql_list];
    // NSLog(@"id title created type lastupdated task_count");
    while ([results next]) {
      /*
      NSLog(@"%@ %@  %@ %@ %@ %@ ", [results stringForColumn:@"id"],
            [results stringForColumn:@"title"],
            [NSNumber numberWithInt:[results intForColumn:@"created"]],
            [NSNumber numberWithInt:[results intForColumn:@"type"]],
            [NSNumber numberWithInt:[results intForColumn:@"lastupdated"]],
            [NSNumber numberWithInt:[results intForColumn:@"task_count"]]);
       */
    }

    [results close];

    results = [db executeQuery:dumpsql_task];
    //NSLog(@"id listID title created type priority reminder repeat deleted \
              completed completionDate lastupdated");
    while ([results next]) {
      /**
       NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@",
            [results stringForColumn:@"id"],
            [results stringForColumn:@"listID"],
            [results stringForColumn:@"title"],
            [NSNumber numberWithInt:[results intForColumn:@"created"]],
            [NSNumber numberWithInt:[results intForColumn:@"type"]],
            [NSNumber numberWithInt:[results intForColumn:@"priority"]],
            [NSNumber numberWithInt:[results intForColumn:@"reminder"]],
            [NSNumber numberWithInt:[results intForColumn:@"repeat"]],
            [NSNumber numberWithInt:[results intForColumn:@"deleted"]],
            [NSNumber numberWithInt:[results intForColumn:@"completed"]],
            [NSNumber numberWithInt:[results intForColumn:@"completionDate"]],
            [NSNumber numberWithInt:[results intForColumn:@"lastupdated"]]);
       */
    }

  }];

  // NSLog(@"\n\n ===== LIST TABLE ======== \n %@",
  // [[self fetchTaskForList:nil] description]);
}

// ===================================================================

#pragma mark - list methods

- (BOOL)saveList:(SnowList *)list {
  [_queue inDatabase:^(FMDatabase *db) {
    BOOL st3 = [db
        executeUpdate:
            @"INSERT INTO snowlist (id,title,created) VALUES (?,?,?) ",
            [[NSUUID UUID] UUIDString], list.title,
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];

    // NSLog(@"status q3 : %d", st3);

    FMResultSet *results = [db executeQuery:@"SELECT * FROM snowlist"];

    if (results) {
      NSMutableArray *tmp = [NSMutableArray new];
      while ([results next]) {
        SnowList *s = [[SnowList alloc] init];
        s.itemID = [results stringForColumn:@"id"];
        s.title = [results stringForColumn:@"title"];
        s.type = [NSNumber numberWithInteger:[results intForColumn:@"type"]];
        s.created = [results dateForColumn:@"created"];
        s.deleted = [results intForColumn:@"deleted"];
        [tmp addObject:s];
      }

      _cachedList = tmp;
      [self sortList];
    }

  }];

  return YES;
  ;
}

- (void)saveList:(SnowList *)list
    WithCompletionHandler:(void (^)(NSError *error, NSArray *list))handler {
  [_queue inDatabase:^(FMDatabase *db) {
    BOOL st3 = [db
        executeUpdate:
            @"INSERT INTO snowlist (id,title,created) VALUES (?,?,?) ",
            [[NSUUID UUID] UUIDString], list.title,
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]

    ];

    // NSLog(@"status q3 : %d", st3);

    FMResultSet *results = [db executeQuery:@"SELECT * FROM snowlist"];

    if (results) {
      NSMutableArray *tmp = [NSMutableArray new];
      while ([results next]) {
        SnowList *s = [[SnowList alloc] init];
        s.itemID = [results stringForColumn:@"id"];
        s.title = [results stringForColumn:@"title"];
        s.type = [NSNumber numberWithInteger:[results intForColumn:@"type"]];
        s.created = [results dateForColumn:@"created"];
        s.deleted = [results intForColumn:@"deleted"];
        [tmp addObject:s];
      }

      _cachedList = tmp;
      [self sortList];

      handler(nil, _cachedList);
    }

  }];
}

- (void)removeList:(SnowList *)list
    WithCompletionHandler:(void (^)(NSError *error, NSArray *lists))handler {
  // Remove all task associated to that list
  [_queue inDatabase:^(FMDatabase *db) {

    BOOL taskDeleteStatus = NO;
    BOOL listDeleteStatus = NO;

    taskDeleteStatus = [db
        executeUpdate:@"DELETE FROM snowtask WHERE listID = ? ", list.itemID];

    if (taskDeleteStatus) {
      listDeleteStatus =
          [db executeUpdate:@"DELETE FROM snowlist WHERE id = ? ", list.itemID];

      if (listDeleteStatus) {
        FMResultSet *results = [db executeQuery:@"SELECT * FROM snowlist"];

        if (results) {
          NSMutableArray *tmp = [NSMutableArray new];
          while ([results next]) {
            SnowList *s = [[SnowList alloc] init];
            s.itemID = [results stringForColumn:@"id"];
            s.title = [results stringForColumn:@"title"];
            s.type =
                [NSNumber numberWithInteger:[results intForColumn:@"type"]];
            s.created = [results dateForColumn:@"created"];
            s.deleted = [results intForColumn:@"deleted"];
            [tmp addObject:s];
          }

          _cachedList = tmp;
          [self sortList];

          handler(nil, _cachedList);
        }

      } else {
        // NSLog(@"Could not delete list: %@", list.title);
      }

    } else {
      // NSLog(@"Could not delete task associated with %@ ", list.title);
    }

  }];

  // Remove the list

  // Callback should handle deleting notifications
}

- (void)removeAllArchivedTasksWithCompletionHandler:
    (void (^)(NSError *error, NSDictionary *task))handler {
  NSError *error;
  __block BOOL deleteStatus = NO;

  [_queue inDatabase:^(FMDatabase *db) {

    deleteStatus =
        [db executeUpdate:
                @"DELETE FROM snowtask WHERE (deleted = 1 or completed = 1)"];

  }];

  if (!deleteStatus) {
    error =
        [[NSError alloc] initWithDomain:@"SNOW_MODEL" code:500 userInfo:nil];
    handler(error, nil);
    return;
  }

  NSDictionary *listCollection = [self fetchTaskForList:nil];
  handler(nil, listCollection);
}

- (BOOL)updateList:(SnowList *)list {
  BOOL ok = NO;
  FMDatabase *fmDatabase = [FMDatabase databaseWithPath:[_databaseURL path]];
  NSString *insertQuery = @"UPDATE snowlist SET title = ? WHERE id = ?   ";

  [fmDatabase open];

  ok = [fmDatabase executeUpdate:insertQuery, list.title, list.itemID];

  [fmDatabase close];

  return ok;
}

- (void)fetchlist {
  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = [db executeQuery:@"SELECT * FROM snowlist"];

    if (results) {
      NSMutableArray *tmp = [NSMutableArray new];
      while ([results next]) {
        SnowList *s = [[SnowList alloc] init];
        s.itemID = [results stringForColumn:@"id"];
        s.title = [results stringForColumn:@"title"];
        s.type = [NSNumber numberWithInteger:[results intForColumn:@"type"]];
        s.created = [results dateForColumn:@"created"];
        s.deleted = [results intForColumn:@"deleted"];
        s.taskcount =
            [NSNumber numberWithInteger:[results intForColumn:@"task_count"]];
        [tmp addObject:s];
        // //NSLog(@"snow content %@", [tmp description]);
      }

      _cachedList = tmp;
      [self sortList];
    }

  }];
}

- (void)fetchListWithCompletionHandler:(void (^)(NSError *error,
                                                 NSArray *lists))handler {
  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = [db executeQuery:@"SELECT * FROM snowlist"];

    if (results) {
      NSMutableArray *tmp = [NSMutableArray new];
      while ([results next]) {
        SnowList *s = [[SnowList alloc] init];
        s.itemID = [results stringForColumn:@"id"];
        s.title = [results stringForColumn:@"title"];
        s.type = [NSNumber numberWithInteger:[results intForColumn:@"type"]];
        s.created = [results dateForColumn:@"created"];
        s.deleted = [results intForColumn:@"deleted"];
        s.taskcount =
            [NSNumber numberWithInteger:[results intForColumn:@"task_count"]];

        [tmp addObject:s];
        // //NSLog(@"snow content %@", [tmp description]);
      }

      _cachedList = tmp;
      [self sortList];

      handler(nil, _cachedList);
    }

  }];
}

- (void)fetchListByID:(NSString *)listId
WithCompletionHandler:(void (^)(NSError *error, NSArray *lists))handler {
  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results =
        [db executeQuery:@"SELECT * FROM snowlist WHERE id = ? ", listId];

    if (results) {
      NSMutableArray *tmp = [NSMutableArray new];
      while ([results next]) {
        SnowList *s = [[SnowList alloc] init];
        s.itemID = [results stringForColumn:@"id"];
        s.title = [results stringForColumn:@"title"];
        s.type = [NSNumber numberWithInteger:[results intForColumn:@"type"]];
        s.created = [results dateForColumn:@"created"];
        s.deleted = [results intForColumn:@"deleted"];
        s.taskcount =
            [NSNumber numberWithInteger:[results intForColumn:@"task_count"]];

        [tmp addObject:s];
        // //NSLog(@"snow content %@", [tmp description]);
      }

      _cachedList = tmp;
      [self sortList];

      handler(nil, _cachedList);
    }

  }];
}

// List with Task

- (void)fetchListContainingTasksWithCompletionHandler:
    (void (^)(NSError *error, NSArray *lists))handler {
  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results =
        [db executeQuery:@"SELECT * from snowlist WHERE id in (SELECT DISTINCT "
            @"listID FROM snowtask WHERE completed = 0) "];

    if (results) {
      NSMutableArray *tmp = [NSMutableArray new];
      while ([results next]) {
        SnowList *s = [[SnowList alloc] init];
        s.itemID = [results stringForColumn:@"id"];
        s.title = [results stringForColumn:@"title"];
        s.type = [NSNumber numberWithInteger:[results intForColumn:@"type"]];
        s.created = [results dateForColumn:@"created"];
        s.deleted = [results intForColumn:@"deleted"];
        s.taskcount =
            [NSNumber numberWithInteger:[results intForColumn:@"task_count"]];

        [tmp addObject:s];
        // //NSLog(@"snow content %@", [tmp description]);
      }

      handler(nil, tmp);
    }

  }];
}

- (void)sortList {
  _cachedList = [_cachedList
      sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *f1 = [(SnowList *)obj1 created];
        NSDate *f2 = [(SnowList *)obj2 created];

        return [f2 compare:f1];
      }];
}

- (void)sortTask {
  _cachedTask = [_cachedTask
      sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

        NSDate *f1 = [(SnowTask *)obj1 created];
        NSDate *f2 = [(SnowTask *)obj2 created];

        return [f2 compare:f1];

      }];
}

// ===================================================================

#pragma mark - Task methods

- (void)saveTask:(SnowTask *)task
    WithCompletionHandler:
        (void (^)(NSError *error, NSDictionary *listSet))handler {
  __block BOOL queryStatus = NO;

  NSError *error;

  [_queue inDatabase:^(FMDatabase *db) {

    NSNumber *reminder = [NSNumber numberWithDouble:0];
    NSString *repeat = @"none";

    if (task.reminder) {
      reminder =
          [NSNumber numberWithDouble:[task.reminder timeIntervalSince1970]];
    }

    if (task.repeat) {
      repeat = task.repeat;
    }

    NSString *taskInsertQuery;

    taskInsertQuery = @"INSERT INTO snowtask "
        @"(id,listID,title,created,reminder,repeat,priority,lastupdated) "
        @"VALUES " @"(?,?,?,?,?,?,?,?) ";

    queryStatus = [db
        executeUpdate:
            taskInsertQuery, task.itemID, task.listID, task.title,
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],
            reminder, repeat, task.priority,
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];

    if (!queryStatus) {
      // NSLog(@" Last Error: %@", [db lastErrorMessage]);
    }

  }];

  if (!queryStatus) {
    error =
        [[NSError alloc] initWithDomain:@"SNOW_MODEL" code:500 userInfo:nil];
    handler(error, nil);
    return;
  }

  NSDictionary *listCollection = [self fetchTaskForList:nil];
  handler(nil, listCollection);
}

- (void)removeTask:(SnowTask *)task
    WithCompletionHandler:
        (void (^)(NSError *error, NSDictionary *task))handler {

  NSError *error;
  __block BOOL deleteStatus = NO;

  [_queue inDatabase:^(FMDatabase *db) {

    deleteStatus =
        [db executeUpdate:@"DELETE FROM snowtask WHERE id = ?", task.itemID];

  }];

  if (!deleteStatus) {
    error =
        [[NSError alloc] initWithDomain:@"SNOW_MODEL" code:500 userInfo:nil];
    handler(error, nil);
    return;
  }

  NSDictionary *listCollection = [self fetchTaskForList:nil];
  handler(nil, listCollection);
}

- (void)updateTask:(SnowTask *)task
    WithCompletionHandler:
        (void (^)(NSError *error, NSDictionary *task))handler {
  __block BOOL queryStatus = NO;
  NSError *error;

  [_queue inDatabase:^(FMDatabase *db) {

    NSNumber *reminder = [NSNumber numberWithDouble:0];
    if (task.reminder) {
      reminder =
          [NSNumber numberWithDouble:[task.reminder timeIntervalSince1970]];
    }

    queryStatus = [db
        executeUpdate:
            @"UPDATE snowtask set title = ?, listID = "
            @"?,reminder = ? , repeat = ?, completed = ?, completionDate = "
            @"?,  priority = ?, deleted = ?, lastupdated = ?  WHERE id = ? ",
            task.title, task.listID, reminder, task.repeat,
            [NSNumber numberWithBool:task.completed],
            [NSNumber
                numberWithDouble:[task.completionDate timeIntervalSince1970]],
            task.priority, [NSNumber numberWithBool:task.deleted],
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],
            task.itemID];

  }];

  if (!queryStatus) {
    error =
        [[NSError alloc] initWithDomain:@"SNOW_MODEL" code:500 userInfo:nil];
    handler(error, nil);
    return;
  }

  NSDictionary *listCollection = [self fetchTaskForList:nil];

  handler(nil, listCollection);
}

- (NSDictionary *)fetchArchivedTaskForList:(SnowList *)list {
  NSMutableDictionary *listCollectionTable = nil;

  NSMutableDictionary *listTable = [NSMutableDictionary new];

  NSString *get_all_tasks;

  NSString *get_tasks_for_list =
      @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.listID = ?  and (task.deleted = "
      @"1 " @" or " @"task.completed = 1)  ORDER BY  "
      @"task.lastupdated DESC ";

  get_all_tasks = @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and (task.deleted = 1  or "
      @"task.completed = 1)  ORDER BY  " @"task.lastupdated DESC ";

  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = nil;

    if (!list) {
      results = [db executeQuery:get_all_tasks];
    } else {
      results = [db executeQuery:get_tasks_for_list, list.itemID];
    }

    while ([results next]) {
      SnowList *list = [[SnowList alloc] init];
      list.itemID = [results stringForColumn:@"list_id"];
      list.title = [results stringForColumn:@"list_name"];
      list.lastupdated = [results dateForColumn:@"list_updated"];
      list.taskcount =
          [NSNumber numberWithInt:[results intForColumn:@"task_count"]];

      if (![listTable objectForKey:list.itemID]) {
        list.tasklist = [NSMutableArray new];
        [listTable setObject:list forKey:list.itemID];
      }

      SnowTask *task = [[SnowTask alloc] init];
      task.itemID = [results stringForColumn:@"id"];

      task.listID = [results stringForColumn:@"listID"];
      task.title = [results stringForColumn:@"title"];
      task.created = [results dateForColumn:@"created"];
      task.priority =
          [NSNumber numberWithInt:[results intForColumn:@"priority"]];

      if ([results intForColumn:@"reminder"] > 0) {
        task.reminder = [results dateForColumn:@"reminder"];
      }

      task.repeat = [results stringForColumn:@"repeat"];
      task.deleted = [results boolForColumn:@"deleted"];
      task.completed = [results boolForColumn:@"completed"];
      task.completionDate = [results dateForColumn:@"completionDate"];
      task.lastupdated = [results dateForColumn:@"lastupdated"];

      if ([listTable objectForKey:task.listID]) {
        SnowList *savedList = [listTable objectForKey:task.listID];
        [savedList.tasklist addObject:task];
      }
    }

  }];

  if ([listTable count] > 0) {
    listCollectionTable = listTable;
  }

  return listCollectionTable;
}

- (NSDictionary *)fetchDeletedTaskForList:(SnowList *)list {

  NSMutableDictionary *listCollectionTable = nil;

  NSMutableDictionary *listTable = [NSMutableDictionary new];

  NSString *get_all_tasks;

  NSString *get_tasks_for_list =
      @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.listID = ?  and task.deleted = 1 "
      @"and " @"task.completed = 0  ORDER BY " @"task.lastupdated DESC ";

  get_all_tasks = @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.deleted = 1 and "
      @"task.completed = 0  ORDER BY  " @"task.lastupdated DESC ";

  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = nil;

    if (!list) {
      results = [db executeQuery:get_all_tasks];
    } else {
      results = [db executeQuery:get_tasks_for_list, list.itemID];
    }

    while ([results next]) {
      SnowList *list = [[SnowList alloc] init];
      list.itemID = [results stringForColumn:@"list_id"];
      list.title = [results stringForColumn:@"list_name"];
      list.lastupdated = [results dateForColumn:@"list_updated"];
      list.taskcount =
          [NSNumber numberWithInt:[results intForColumn:@"task_count"]];

      if (![listTable objectForKey:list.itemID]) {
        list.tasklist = [NSMutableArray new];
        [listTable setObject:list forKey:list.itemID];
      }

      SnowTask *task = [[SnowTask alloc] init];
      task.itemID = [results stringForColumn:@"id"];

      task.listID = [results stringForColumn:@"listID"];
      task.title = [results stringForColumn:@"title"];
      task.created = [results dateForColumn:@"created"];
      task.priority =
          [NSNumber numberWithInt:[results intForColumn:@"priority"]];

      if ([results intForColumn:@"reminder"] > 0) {
        task.reminder = [results dateForColumn:@"reminder"];
      }

      task.repeat = [results stringForColumn:@"repeat"];
      task.deleted = [results boolForColumn:@"deleted"];
      task.completed = [results boolForColumn:@"completed"];
      task.completionDate = [results dateForColumn:@"completionDate"];
      task.lastupdated = [results dateForColumn:@"lastupdated"];

      if ([listTable objectForKey:task.listID]) {
        SnowList *savedList = [listTable objectForKey:task.listID];
        [savedList.tasklist addObject:task];
      }
    }

  }];

  if ([listTable count] > 0) {
    listCollectionTable = listTable;
  }

  return listCollectionTable;
}

- (NSDictionary *)fetchCompletedTaskForList:(SnowList *)list {
  NSMutableDictionary *listCollectionTable = nil;

  NSMutableDictionary *listTable = [NSMutableDictionary new];

  NSString *get_all_tasks;

  NSString *get_tasks_for_list =
      @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.listID = ?  and task.deleted = 0 "
      @"and " @"task.completed = 1  ORDER BY  " @"task.lastupdated DESC ";

  get_all_tasks = @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.deleted = 0 and "
      @"task.completed = 1  ORDER BY  " @"task.lastupdated DESC ";

  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = nil;

    if (!list) {
      results = [db executeQuery:get_all_tasks];
    } else {
      results = [db executeQuery:get_tasks_for_list, list.itemID];
    }

    while ([results next]) {
      SnowList *list = [[SnowList alloc] init];
      list.itemID = [results stringForColumn:@"list_id"];
      list.title = [results stringForColumn:@"list_name"];
      list.lastupdated = [results dateForColumn:@"list_updated"];
      list.taskcount =
          [NSNumber numberWithInt:[results intForColumn:@"task_count"]];

      if (![listTable objectForKey:list.itemID]) {
        list.tasklist = [NSMutableArray new];
        [listTable setObject:list forKey:list.itemID];
      }

      SnowTask *task = [[SnowTask alloc] init];
      task.itemID = [results stringForColumn:@"id"];

      task.listID = [results stringForColumn:@"listID"];
      task.title = [results stringForColumn:@"title"];
      task.created = [results dateForColumn:@"created"];
      task.priority =
          [NSNumber numberWithInt:[results intForColumn:@"priority"]];

      if ([results intForColumn:@"reminder"] > 0) {
        task.reminder = [results dateForColumn:@"reminder"];
      }

      task.repeat = [results stringForColumn:@"repeat"];
      task.deleted = [results boolForColumn:@"deleted"];
      task.completed = [results boolForColumn:@"completed"];
      task.completionDate = [results dateForColumn:@"completionDate"];
      task.lastupdated = [results dateForColumn:@"lastupdated"];

      if ([listTable objectForKey:task.listID]) {
        SnowList *savedList = [listTable objectForKey:task.listID];
        [savedList.tasklist addObject:task];
      }
    }

  }];

  if ([listTable count] > 0) {
    listCollectionTable = listTable;
  }

  return listCollectionTable;
}

- (NSDictionary *)fetchTaskForList:(SnowList *)list {
  NSMutableDictionary *listCollectionTable = nil;

  NSMutableDictionary *listTable = [NSMutableDictionary new];

  NSString *get_all_tasks;

  NSString *get_tasks_for_list =
      @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.listID = ?  and task.deleted = 0 "
      @"and "
      @"task.completed = 0  ORDER BY list_updated DESC, task.lastupdated DESC ";

  get_all_tasks = @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.deleted = 0 and "
      @"task.completed = 0  ORDER BY  list_updated DESC, task.lastupdated "
      @" DESC ";

  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = nil;

    if (!list) {
      results = [db executeQuery:get_all_tasks];
    } else {
      results = [db executeQuery:get_tasks_for_list, list.itemID];
    }

    while ([results next]) {
      SnowList *list = [[SnowList alloc] init];
      list.itemID = [results stringForColumn:@"list_id"];
      list.title = [results stringForColumn:@"list_name"];
      list.lastupdated = [results dateForColumn:@"list_updated"];
      list.taskcount =
          [NSNumber numberWithInt:[results intForColumn:@"task_count"]];

      if (![listTable objectForKey:list.itemID]) {
        list.tasklist = [NSMutableArray new];
        [listTable setObject:list forKey:list.itemID];
      }

      SnowTask *task = [[SnowTask alloc] init];
      task.itemID = [results stringForColumn:@"id"];

      task.listID = [results stringForColumn:@"listID"];
      task.title = [results stringForColumn:@"title"];
      task.created = [results dateForColumn:@"created"];
      task.priority =
          [NSNumber numberWithInt:[results intForColumn:@"priority"]];

      if ([results intForColumn:@"reminder"] > 0) {
        task.reminder = [results dateForColumn:@"reminder"];
      }

      task.repeat = [results stringForColumn:@"repeat"];
      task.deleted = [results boolForColumn:@"deleted"];
      task.completed = [results boolForColumn:@"completed"];
      task.completionDate = [results dateForColumn:@"completionDate"];
      task.lastupdated = [results dateForColumn:@"lastupdated"];

      if ([listTable objectForKey:task.listID]) {
        SnowList *savedList = [listTable objectForKey:task.listID];
        [savedList.tasklist addObject:task];
      }
    }

  }];

  if ([listTable count] > 0) {
    listCollectionTable = listTable;
  }

  return listCollectionTable;
}

- (NSDictionary *)fetchTaskForList:(SnowList *)list
                      withPriority:(NSNumber *)priority {
  NSMutableDictionary *listCollectionTable = nil;

  NSMutableDictionary *listTable = [NSMutableDictionary new];

  NSString *get_all_tasks;

  NSString *get_tasks_for_list =
      @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.listID = ?  and task.deleted = 0 "
      @"and "
      @"task.completed = 0 and task.priority = ? ORDER BY list_updated DESC, "
      @"task.lastupdated DESC ";

  get_all_tasks = @"SELECT task.id,task.listID,task.title,task.created,"
      @"task.priority,task.reminder,task.repeat,task.deleted,task.completed,"
      @"task.completionDate,task.lastupdated, list.id as list_id, "
      @" list.title as list_name, list.lastupdated as "
      @"list_updated,list.task_count  from snowtask  task , snowlist list "
      @" WHERE task.listID = list.id and task.deleted = 0 and "
      @"task.completed = 0 and task.priority = ?  ORDER BY list_updated DESC, "
      @"task.lastupdated DESC ";

  [_queue inDatabase:^(FMDatabase *db) {
    FMResultSet *results = nil;

    if (!list) {
      results = [db executeQuery:get_all_tasks, priority];
    } else {
      results = [db executeQuery:get_tasks_for_list, list.itemID, priority];
    }

    while ([results next]) {
      SnowList *list = [[SnowList alloc] init];
      list.itemID = [results stringForColumn:@"list_id"];
      list.title = [results stringForColumn:@"list_name"];
      list.lastupdated = [results dateForColumn:@"list_updated"];
      list.taskcount =
          [NSNumber numberWithInt:[results intForColumn:@"task_count"]];

      if (![listTable objectForKey:list.itemID]) {
        list.tasklist = [NSMutableArray new];
        [listTable setObject:list forKey:list.itemID];
      }

      SnowTask *task = [[SnowTask alloc] init];
      task.itemID = [results stringForColumn:@"id"];

      task.listID = [results stringForColumn:@"listID"];
      task.title = [results stringForColumn:@"title"];
      task.created = [results dateForColumn:@"created"];
      task.priority =
          [NSNumber numberWithInt:[results intForColumn:@"priority"]];

      if ([results intForColumn:@"reminder"] > 0) {
        task.reminder = [results dateForColumn:@"reminder"];
      }

      task.repeat = [results stringForColumn:@"repeat"];
      task.deleted = [results boolForColumn:@"deleted"];
      task.completed = [results boolForColumn:@"completed"];
      task.completionDate = [results dateForColumn:@"completionDate"];
      task.lastupdated = [results dateForColumn:@"lastupdated"];

      if ([listTable objectForKey:task.listID]) {
        SnowList *savedList = [listTable objectForKey:task.listID];
        [savedList.tasklist addObject:task];
      }
    }

  }];

  if ([listTable count] > 0) {
    listCollectionTable = listTable;
  }

  return listCollectionTable;
}

// ==================================================================
#pragma mark - Timer

- (void)saveTimer:(SnowTimer *)timer {
  [_queue inDatabase:^(FMDatabase *db) {
    NSString *st = @"INSERT INTO snowtimer "
        @" (id,title,expiration,lastupdated) VALUES (?,?,?,?); ";

    NSNumber *lu =
        [NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceNow]];

    // NSLog(@"LAST UPDATED %@ ", lu);

    NSNumber *lu2 =
        [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];

    // NSLog(@"LAST UPDATED %@ ", lu2);

    BOOL queryStatus = [db
        executeUpdate:
            st, timer.itemId, timer.timerName,
            [NSNumber numberWithInt:timer.timerValue],
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];

    if (!queryStatus) {
      // NSLog(@"Could not saved timer object : %@", [db lastErrorMessage]);
    }

  }];
}

- (void)removeSavedTimer:(SnowTimer *)tm {
  [_queue inDatabase:^(FMDatabase *db) {
    NSString *st = @"DELETE FROM snowtimer WHERE id =?";

    BOOL queryStatus = [db executeUpdate:st, tm.itemId];

    if (!queryStatus) {
      // NSLog(@"Could not remove saved timer object : %@", [db
      // lastErrorMessage]);
    }

  }];
}

- (SnowTimer *)fetchSavedTimerForKey:(NSString *)key {

  __block SnowTimer *timer;

  [_queue inDatabase:^(FMDatabase *db) {

    NSString *st = @"SELECT * FROM  snowtimer WHERE title = ?";

    FMResultSet *results = [db executeQuery:st, key];

    while ([results next]) {
      SnowTimer *tmp = [[SnowTimer alloc] init];
      tmp.itemId = [results stringForColumn:@"id"];
      tmp.timerName = [results stringForColumn:@"title"];
      tmp.timerValue = [results intForColumn:@"expiration"];
      tmp.timerState = [results intForColumn:@"state"];
      double lastupdated = [results intForColumn:@"lastupdated"];
      if (lastupdated > 0) {
        tmp.startDate = [results dateForColumn:@"lastupdated"];
      }

      timer = tmp;
    }

  }];

  return timer;
}

- (void)updatedTimer:(SnowTimer *)timer {
  [_queue inDatabase:^(FMDatabase *db) {
    NSString *st = @"UPDATE snowtimer set state = ?, expiration = ?, "
        @"lastupdated = ? WHERE id = ?";
    BOOL queryStatus = [db
        executeUpdate:
            st, [NSNumber numberWithInteger:timer.timerState],
            [NSNumber numberWithInt:timer.timerValue],
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],
            timer.itemId];

    if (!queryStatus) {
      // NSLog(@"Could not update timer object : %@", [db lastErrorMessage]);
    }

  }];
}

// ===================================================================

#pragma mark - THEMES

// Color themes
- (void)updateDefaultTheme:(SnowTheme *)theme {
  [_queue inDatabase:^(FMDatabase *db) {
    BOOL updateStatus = NO;
    int total = 0;

    FMResultSet *results = nil;

    if (theme.themeKey && ([theme.themeKey length] > 0)) {
      // Fetch & check : do we have something set already ?
      results =
          [db executeQuery:
                  @"SELECT COUNT(*) AS total FROM snowlist_preferences WHERE "
                  @"domain = ? and key_name = ?",
                  [NSString stringWithFormat:@"appearence"],
                  [NSString stringWithFormat:@"theme"]];

      [results next];

      total = [results intForColumn:@"total"];
      [results close];

      // if yes update , else insert
      if (total > 0) {
        updateStatus = [db
            executeUpdate:@"UPDATE snowlist_preferences SET key_val = ? "
                          @"WHERE key_name = ? and domain = ?",
                          theme.themeKey, [NSString stringWithFormat:@"theme"],
                          [NSString stringWithFormat:@"appearence"]];
      } else {
        updateStatus = [db
            executeUpdate:@"INSERT INTO snowlist_preferences "
                          @"(domain,key_name,key_val) VALUES(?,?,?) ",
                          [NSString stringWithFormat:@"appearence"],
                          [NSString stringWithFormat:@"theme"], theme.themeKey];
      }

      if (!updateStatus) {
        // NSLog(@" failed background update %@ ", [db lastErrorMessage]);
      }
    }

  }];
}

- (SnowTheme *)fetchDefaultTheme {

  FMDatabase *db = [FMDatabase databaseWithPath:[_databaseURL path]];

  FMResultSet *results = nil;

  [db open];

  results = [db executeQuery:@"SELECT * FROM snowlist_preferences WHERE "
                             @"domain = ? and key_name = ?",
                             [NSString stringWithFormat:@"appearence"],
                             [NSString stringWithFormat:@"theme"]];

  if (results) {
    SnowTheme *theme;
    while ([results next]) {
      NSString *themeName = [results stringForColumn:@"key_val"];
      theme = [[SnowTheme alloc] initWithThemeName:themeName];
    }

    [db close];

    return theme;
  } else {
    // NSLog(@"Last Error: %@", [db lastErrorMessage]);
    [db close];
  }

  return nil;
}

// Image background
- (void)updateDefaultBackground:(SnowBackground *)background {
  [_queue inDatabase:^(FMDatabase *db) {
    BOOL updateStatus = NO;
    FMResultSet *results = nil;
    int total = 0;

    if (background.backgroundKey && ([background.backgroundKey length] > 0)) {
      // Fetch & check : do we have something set already ?
      results =
          [db executeQuery:
                  @"SELECT COUNT(*) AS total FROM snowlist_preferences WHERE "
                  @"domain = ? and key_name = ?",
                  [NSString stringWithFormat:@"appearence"],
                  [NSString stringWithFormat:@"background"]];

      [results next];

      total = [results intForColumn:@"total"];

      [results close];

      // if yes update , else insert
      if (total > 0) {
        updateStatus =
            [db executeUpdate:@"UPDATE snowlist_preferences SET key_val = ? "
                              @"WHERE key_name = ? and domain = ?",
                              background.backgroundKey,
                              [NSString stringWithFormat:@"background"],
                              [NSString stringWithFormat:@"appearence"]];
      } else {
        updateStatus =
            [db executeUpdate:@"INSERT INTO snowlist_preferences "
                              @"(domain,key_name,key_val) VALUES(?,?,?) ",
                              [NSString stringWithFormat:@"appearence"],
                              [NSString stringWithFormat:@"background"],
                              background.backgroundKey];
      }

      if (!updateStatus) {
        // NSLog(@" failed background update %@ ", [db lastErrorMessage]);
      }
    }
  }];
}

- (SnowBackground *)fetchDefaultBackground {

  /*
    [_queue inDatabase:^(FMDatabase* db) {
  FMDatabase *db = [FMDatabase databaseWithPath:[_databaseURL path]];

  FMResultSet *results = nil;

  [db open];

  results = [db executeQuery:@"SELECT * FROM snowlist_preferences WHERE "
                             @"domain = ? and key_name = ?",
                             [NSString stringWithFormat:@"appearence"],
                             [NSString stringWithFormat:@"background"]];

  if (results) {
    SnowBackground *background;
    while ([results next]) {
      NSString *backgroundName = [results stringForColumn:@"key_val"];
      background =
          [[SnowBackground alloc] initWithBackgroundName:backgroundName];
    }

    [db close];

    return background;
  } else {
    //NSLog(@"Last Error: %@", [db lastErrorMessage]);
    [db close];
  }

   }];
*/

  return nil;
}

#pragma mark -  Sound alert preferences
- (void)updateDefaultSound:(SnowSound *)sound {

  [_queue inDatabase:^(FMDatabase *db) {
    BOOL updateStatus = NO;
    FMResultSet *results = nil;
    int total = 0;

    if (sound.soundName && ([sound.soundName length] > 0)) {
      // Fetch & check : do we have something set already ?
      results =
          [db executeQuery:
                  @"SELECT COUNT(*) AS total FROM snowlist_preferences WHERE "
                  @"domain = ? and key_name = ?",
                  [NSString stringWithFormat:@"audio"],
                  [NSString stringWithFormat:@"alarm"]];

      [results next];

      total = [results intForColumn:@"total"];

      [results close];

      // if yes update , else insert
      if (total > 0) {
        updateStatus = [db
            executeUpdate:@"UPDATE snowlist_preferences SET key_val = ? "
                          @"WHERE key_name = ? and domain = ?",
                          sound.soundName, [NSString stringWithFormat:@"alarm"],
                          [NSString stringWithFormat:@"audio"]];
      } else {
        updateStatus =
            [db executeUpdate:@"INSERT INTO snowlist_preferences "
                              @"(domain,key_name,key_val) VALUES(?,?,?) ",
                              [NSString stringWithFormat:@"audio"],
                              [NSString stringWithFormat:@"alarm"],
                              sound.soundName];
      }

      if (!updateStatus) {
        // NSLog(@" failed sound update %@ ", [db lastErrorMessage]);
      }
    }
  }];
}

- (SnowSound *)fetchDefaultSound {

  FMDatabase *db = [FMDatabase databaseWithPath:[_databaseURL path]];

  FMResultSet *results = nil;

  [db open];

  results = [db executeQuery:@"SELECT * FROM snowlist_preferences WHERE "
                             @"domain = ? and key_name = ?",
                             [NSString stringWithFormat:@"audio"],
                             [NSString stringWithFormat:@"alarm"]];

  if (results) {
    SnowSound *sound;
    while ([results next]) {
      NSString *themeName = [results stringForColumn:@"key_val"];
      sound = [[SnowSound alloc] initWithSoundName:themeName];
    }

    [db close];

    return sound;
  } else {
    // NSLog(@"Last Error: %@", [db lastErrorMessage]);
    [db close];
  }

  return nil;
}

@end
