//
//  SnowTaskAllTVC.m
//  snow
//
//  Created by samuel maura on 4/8/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTaskAllTVC.h"
#import "SnowNotificationManager.h"
#import "SnowDataManager.h"
#import "SnowCardA.h"

#import "SnowListManager.h"
#import "SnowAppearanceManager.h"

@interface SnowTaskAllTVC ()

@end

@implementation SnowTaskAllTVC {
  SnowListManager *_listManager;
  NSUInteger _currentSectionCount;
  UISegmentedControl *_filter;
  UIView *_wrapper;
  NSUInteger _taskStatus;
  NSArray *_archivedList;
  BOOL _firstLoad;

  NSString *_emptyMessage;
  UILabel *_emptyLabel;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _emptyMessage = @"No archived tasks";
  _firstLoad = YES;
  // _forceReload =  NO;

  self.title = @"Archive";

  UIBarButtonItem *drawer = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_menu_drawer"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(toggleMenu:)];

  self.navigationItem.leftBarButtonItem = drawer;

  UIBarButtonItem *clearAll =
      [[UIBarButtonItem alloc] initWithTitle:@"clear all"
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(clearAllTasks:)];

  /*
                               target:self
                               action:@selector(clearAllTasks:)];
  */

  self.navigationItem.rightBarButtonItem = clearAll;

  UINib *cellNIB = [UINib nibWithNibName:@"SnowCardA" bundle:nil];

  [self.tableView registerClass:[SnowCardA2 class]
         forCellReuseIdentifier:@"snow_card_a2"];

  [self.tableView registerNib:cellNIB forCellReuseIdentifier:@"snow_card_a"];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100.0;

  CGRect wrapperFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 100);
 // CGRect segmentFrame = CGRectInset(wrapperFrame, 40, 25);

  UIView *segmentWrapper = [[UIView alloc] initWithFrame:wrapperFrame];

  // segmentWrapper.backgroundColor = [UIColor blackColor];

  UISegmentedControl *taskFilter = [[UISegmentedControl alloc]
      initWithItems:@[ @"all", @"completed", @"deleted" ]];

  /*
taskFilter.tintColor =
    [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  */

  taskFilter.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  // taskFilter.frame = segmentFrame;
  _wrapper = segmentWrapper;
  _filter = taskFilter;

  self.tableView.tableHeaderView = _wrapper;
  [_wrapper addSubview:_filter];

  [_filter addTarget:self
                action:@selector(filterTasks:)
      forControlEvents:UIControlEventValueChanged];

  taskFilter.selectedSegmentIndex = 0;

  [self positionSegmentView];

  _listManager = [SnowListManager new];
}

- (void)positionSegmentView {

  _filter.translatesAutoresizingMaskIntoConstraints = NO;

  [self.tableView.tableHeaderView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.tableView.tableHeaderView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_filter
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1
                                  constant:0]];

  [self.tableView.tableHeaderView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.tableView.tableHeaderView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_filter
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1
                                  constant:0]];
}

- (void)viewWillLayoutSubviews {
  /*
  CGRect segmentFrame = CGRectMake(50, 5, 180, 44);
  CGRect wrapperFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 80);

  _filter.frame =  segmentFrame;
*/
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [_listManager refreshArchived];
  _currentSectionCount = [[_listManager fetchArchivedLists] count];

  if (!_firstLoad) {
    //_forceReload = YES;
    [self filterTasks:_filter];
  }

  _firstLoad = NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.

  NSInteger section_count;

  switch (_taskStatus) {
  case 0: {
    NSLog(@" ALL SECTION COUNT = %ld ",
          [[_listManager fetchArchivedLists] count]);
    section_count = [[_listManager fetchArchivedLists] count];
  } break;
  case 1: {
    NSLog(@" COMPLETED  SECTION COUNT = %ld ",
          [[_listManager fetchCompletedLists] count]);
    section_count = [[_listManager fetchCompletedLists] count];
  } break;
  case 2: {
    NSLog(@"DELETED SECTION COUNT = %ld ",
          [[_listManager fetchDeletedLists] count]);
    section_count = [[_listManager fetchDeletedLists] count];
  } break;
  default:
    section_count = 0;
    break;
  }

  if (_emptyLabel == nil) {
    _emptyLabel = [[UILabel alloc] init];
  }
  [self showEmptyDataMessageIfNeeded:section_count
                             WithMsg:_emptyMessage
                            AndLabel:_emptyLabel];

  return section_count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.

  switch (_taskStatus) {
  case 0: {
    return [[[[_listManager fetchArchivedLists]
        objectAtIndex:section] tasklist] count];
  } break;
  case 1: {
    return [[[[_listManager fetchCompletedLists]
        objectAtIndex:section] tasklist] count];
  }
  case 2: {
    return [[[[_listManager fetchDeletedLists]
        objectAtIndex:section] tasklist] count];
  } break;
  default:
    return 0;
    break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  SnowCardA2 *cell =
      [tableView dequeueReusableCellWithIdentifier:@"snow_card_a2"
                                      forIndexPath:indexPath];

  [self configCell:cell WithIdentifier:1 atIndexPath:indexPath];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 88.0;
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  SnowList *list = nil;

  switch (_taskStatus) {
  case 0:
    list = [[_listManager fetchArchivedLists] objectAtIndex:section];
    break;
  case 1:
    list = [[_listManager fetchCompletedLists] objectAtIndex:section];
    break;
  case 2:
    list = [[_listManager fetchDeletedLists] objectAtIndex:section];
    break;

  default:
    break;
  }

  //  SnowList *list = [[_listManager fetchArchivedLists]
  //  objectAtIndex:section];

  CGRect viewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 80);

  CGRect labelFrame = CGRectInset(viewFrame, 10, 10);

  //  CGRectMake(10.0, 10.0, self.tableView.frame.size.width, 34.0);

  UILabel *header = [[UILabel alloc] initWithFrame:labelFrame];

  // header.backgroundColor =[UIColor darkGrayColor];

  header.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.7];

  // [[SnowAppearanceManager sharedInstance] currentTheme].secondary;

  header.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:28];

  //[UIFont fontWithName:@"Helvetica" size:17];

  //  header.text = [NSString
  //      stringWithFormat:@" %@ - total %@  pending %ld", list.title,
  //                       [list.taskcount stringValue], [list.tasklist count]];

  header.text = [NSString stringWithFormat:@" %@", list.title];

  UIView *head = [[UIView alloc] initWithFrame:viewFrame];
  [head addSubview:header];

  return head;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  SnowList *selectedList;
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

  switch (_taskStatus) {
  case 0: {
    selectedList =
        [[_listManager fetchArchivedLists] objectAtIndex:indexPath.section];

  } break;
  case 1: {
    selectedList =
        [[_listManager fetchCompletedLists] objectAtIndex:indexPath.section];
  } break;
  case 2: {
    selectedList =
        [[_listManager fetchDeletedLists] objectAtIndex:indexPath.section];

  } break;
  default:
    selectedList = nil;
    break;
  }

  SnowTask *selectedTask = [selectedList.tasklist objectAtIndex:indexPath.row];

  SnowTaskDetailsTVC *details =
      [[SnowTaskDetailsTVC alloc] initWithStyle:UITableViewStyleGrouped];

  details.delegate = self;
  details.detailTask = selectedTask;
  details.parentList = selectedList;

  [self.navigationController pushViewController:details animated:YES];
}

#pragma mark - SnowTaskDetailTVCDelegate

- (void)popDetail {
  [self.navigationController popViewControllerAnimated:YES];
  //[self reload];
}

#pragma mark -

- (void)toggleMenu:(id)sender {
  self.menuTapped();
}

- (void)configCell:(UITableViewCell *)cellIn
    WithIdentifier:(NSUInteger)identifier
       atIndexPath:(NSIndexPath *)indexPath {

  SnowList *currentList = nil;

  switch (_taskStatus) {
  case 0:
    currentList =
        [[_listManager fetchArchivedLists] objectAtIndex:indexPath.section];
    break;
  case 1:
    currentList =
        [[_listManager fetchCompletedLists] objectAtIndex:indexPath.section];
    break;
  case 2:
    currentList =
        [[_listManager fetchDeletedLists] objectAtIndex:indexPath.section];
    break;

  default:
    break;
  }

  SnowTask *currentTask = [[currentList tasklist] objectAtIndex:indexPath.row];

  SnowCardA2 *cell = (SnowCardA2 *)cellIn;
  SnowTask *x = currentTask;

  static NSDateFormatter *format = nil;

  if (format == nil) {
    format = [[NSDateFormatter alloc] init];
    format.dateStyle = NSDateFormatterShortStyle;
    format.timeStyle = NSDateFormatterShortStyle;
  }

  if (identifier == 1) {

    /*
  cell.dataContainerView.backgroundColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
     */

    cell.dataContainerView.backgroundColor =
        [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:1];

    NSString *state = nil;

    if (x.deleted) {
      state = @"deleted";
    }

    if (x.completed) {
      state = @"completed";
    }

    /*
    cell.taskTitle.text =
        [NSString stringWithFormat:@"%@ - %@", x.title, state];
     */

    cell.taskTitle.text = x.title;
    cell.listName.text =
        currentList
            .title; // [NSString stringWithFormat:@"%@ - %@", x.title, state];

    /*

  if (x.reminder) {
    cell.dueDate.text =
        [NSString stringWithFormat:@"%@", [format stringFromDate:x.reminder]];
  } else {
    cell.dueDate.text = [format stringFromDate:x.created];
  }


  cell.listName.text = currentList.title; //@"Shopping";
*/

    cell.task = currentTask;
    cell.cellPath = indexPath;
    cell.delegate = self;

    cell.deleteTask = ^{
      [self clearTask:x AtIndexPath:indexPath];
    };

    cell.completeTask = ^{
      [self unarchivedTask:x AtIndexPath:indexPath];
    };
  }
}

- (void)clearTask:(SnowTask *)task AtIndexPath:(NSIndexPath *)indexPath {

  [[SnowDataManager sharedInstance]
                 removeTask:task
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks) {
        NSLog(@"Clear operation completed for task ");

      }];

  [self updateTableActionsFor:task AtIndex:indexPath AndRescheduleReminder:NO];
}

- (void)clearAllTasks:(id)sender {

  NSLog(@"Clear all");

  [[SnowDataManager sharedInstance]
      removeAllArchivedTasksWithCompletionHandler:^(NSError *error,
                                                    NSDictionary *task) {
          NSLog(@"All done");

      }];
    
    // ===== Reload table, refresh cache  & take care of empty sections
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       [self filterTasks:_filter];
                   });

}

- (void)unarchivedTask:(SnowTask *)task AtIndexPath:(NSIndexPath *)indexPath {
  task.completed = 0;
  task.deleted = 0;
  task.completionDate = nil;
  BOOL shouldRescheduleReminder = NO;

  if (task.reminder != nil) {
    if ([[NSDate date] timeIntervalSince1970] <
        [task.reminder timeIntervalSince1970]) {
      // Re-enable reminder
      shouldRescheduleReminder = YES;
    } else {
      task.reminder = nil;
      task.repeat = @"none";
    }
  }

  [[SnowDataManager sharedInstance]
                 updateTask:task
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks) {
        NSLog(@"Task was reset successfullly");

      }];

  [self updateTableActionsFor:task
                      AtIndex:indexPath
        AndRescheduleReminder:shouldRescheduleReminder];
}

- (void)updateTableActionsFor:(SnowTask *)task
                      AtIndex:(NSIndexPath *)indexPath
        AndRescheduleReminder:(BOOL)shouldRescheduleReminder {

  // ==== Cache data update ===========//

  NSMutableArray *tmpTaskArray = [NSMutableArray new];

  SnowList *tmpList; //= [_listTableSorted objectAtIndex:indexPath.section];

  switch (_taskStatus) {
  case 0:
    tmpList =
        [[_listManager fetchArchivedLists] objectAtIndex:indexPath.section];
    break;
  case 1:
    tmpList =
        [[_listManager fetchCompletedLists] objectAtIndex:indexPath.section];
    break;
  case 2:
    tmpList =
        [[_listManager fetchDeletedLists] objectAtIndex:indexPath.section];
    break;

  default:
    break;
  }

  for (SnowTask *t in tmpList.tasklist) {
    // exclude task from new list
    if (![task.itemID isEqualToString:t.itemID]) {
      [tmpTaskArray addObject:t];
    }
  }

  // Update list
  tmpList.tasklist = tmpTaskArray;

  [self.tableView beginUpdates];
  [self.tableView deleteRowsAtIndexPaths:@[ indexPath ]
                        withRowAnimation:UITableViewRowAnimationLeft];

  [self.tableView endUpdates];

  //==========  Reschedule notifications if needed  ========//

  if (shouldRescheduleReminder) {
    [[SnowNotificationManager sharedInstance]
        scheduleNotificationWithTask:task];
  }

  // at the end

  // ===== Reload table, refresh cache  & take care of empty sections

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC),
                 dispatch_get_main_queue(), ^{
                   [self filterTasks:_filter];
                 });
}

- (void)filterTasks:(id)sender {
  UISegmentedControl *taskSelector = (UISegmentedControl *)sender;

  _taskStatus = taskSelector.selectedSegmentIndex;

  NSLog(@"Selected %@", [taskSelector titleForSegmentAtIndex:_taskStatus]);

  switch (_taskStatus) {
  case 0: {
    _emptyMessage = @"No archived tasks";
    [_listManager refreshArchived];
    _currentSectionCount = [[_listManager fetchArchivedLists] count];
  } break;
  case 1: {
    _emptyMessage = @"No completed tasks";
    [_listManager refreshCompleted];
    _currentSectionCount = [[_listManager fetchCompletedLists] count];
  } break;
  case 2: {
    _emptyMessage = @"No deleted tasks";
    [_listManager refreshDeleted];
    _currentSectionCount = [[_listManager fetchDeletedLists] count];
  } break;

  default:
    break;
  }

  [self.tableView reloadData];
}

#pragma mark - snowCard2Delegate

- (void)cell:(SnowCardA2 *)cell
    ActionButtonPressedFor:(SnowTask *)task
                   AtIndex:(NSIndexPath *)index {

  UIAlertController *ac = [UIAlertController
      alertControllerWithTitle:@"Task"
                       message:task.title
                preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction *ac1 =
      [UIAlertAction actionWithTitle:@"unarchive"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                               NSLog(@"unarchive");
                               [self unarchivedTask:task AtIndexPath:index];

                             }];

  UIAlertAction *ac2 =
      [UIAlertAction actionWithTitle:@"clear"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                               NSLog(@"Cleared");
                               [self clearTask:task AtIndexPath:index];

                             }];

  UIAlertAction *ac3 =
      [UIAlertAction actionWithTitle:@"cancel"
                               style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction *action) {
                               NSLog(@"Cancelled");

                             }];

  //[ac addAction:ac0];
  [ac addAction:ac1];
  [ac addAction:ac2];
  [ac addAction:ac3];

  ac.view.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  [self presentViewController:ac animated:YES completion:nil];

  if (ac.popoverPresentationController) {
    UITableViewCell *v = (UITableViewCell *)cell;
    ac.popoverPresentationController.sourceRect = v.contentView.frame;
    ac.popoverPresentationController.sourceView = v.contentView;
  }
}

@end
