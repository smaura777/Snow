//
//  SnowAllPendingTaskForList.m
//  snow
//
//  Created by samuel maura on 6/3/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowAllPendingTaskForList.h"
#import "SnowNotificationManager.h"
#import "SnowTaskCreateTVC.h"

#import "SnowCardA.h"

@interface SnowAllPendingTaskForList ()

@end

@implementation SnowAllPendingTaskForList {

  BOOL _firstLoad;
  NSUInteger _currentSectionCount;
  SnowListManager *_listManager;
  UILabel *_emptyLabel;
  NSString *_emptyMessage;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _emptyMessage = @"No tasks";

  _firstLoad = YES;

  UIBarButtonItem *item2 = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_bar_add"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(doThat:)];

  self.navigationItem.rightBarButtonItems = @[ item2 ];

  UINib *cellNIB = [UINib nibWithNibName:@"SnowCardA" bundle:nil];
  [self.tableView registerNib:cellNIB forCellReuseIdentifier:@"snow_card_a"];

  [self.tableView registerClass:[SnowCardA2 class]
         forCellReuseIdentifier:@"snow_card_a2"];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100.0;

  // Uncomment the following line to preserve selection between presentations.
  self.clearsSelectionOnViewWillAppear = YES;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  _listManager = [SnowListManager new];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self reload];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)reload {

  if (_list) {
    [_listManager refreshForList:_list];
  }

  _listTable = [_listManager fetch];
  _currentSectionCount = _listManager.listWithPendingTasksCount;

  if (!_firstLoad) {
    [self.tableView reloadData];
  }

  _firstLoad = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  NSInteger section_count = _listManager.listWithPendingTasksCount;

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
  return [[[[_listManager fetchLists] objectAtIndex:section] tasklist] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"snow_card_a2"
                                      forIndexPath:indexPath];

  [self configCell:cell WithIdentifier:1 atIndexPath:indexPath];

  // Configure the cell...

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  SnowList *selectedList =
      [[_listManager fetchLists] objectAtIndex:indexPath.section];
  SnowTask *selectedTask = [selectedList.tasklist objectAtIndex:indexPath.row];

  SnowTaskDetailsTVC *details =
      [[SnowTaskDetailsTVC alloc] initWithStyle:UITableViewStyleGrouped];

  details.delegate = self;
  details.detailTask = selectedTask;
  details.parentList = selectedList;

  [self.navigationController pushViewController:details animated:YES];
}

- (void)configCell:(UITableViewCell *)cellIn
    WithIdentifier:(NSUInteger)identifier
       atIndexPath:(NSIndexPath *)indexPath {

  SnowList *currentList =
      [[_listManager fetchLists] objectAtIndex:indexPath.section];
  SnowTask *currentTask = [currentList.tasklist objectAtIndex:indexPath.row];

  static NSDateFormatter *format = nil;

  if (format == nil) {
    format = [[NSDateFormatter alloc] init];
    format.dateStyle = NSDateFormatterShortStyle;
    format.timeStyle = NSDateFormatterShortStyle;
  }

  SnowTask *x = currentTask;
  SnowCardA2 *cell = (SnowCardA2 *)cellIn;

  if (identifier == 1) {

    //    cell.dataContainerView.backgroundColor =
    //        [[SnowAppearanceManager sharedInstance] currentTheme].primary;

    cell.dataContainerView.backgroundColor =
        [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:1];

    cell.taskTitle.text = x.title;

    if (x.reminder) {
      cell.dueDate.text =
          [NSString stringWithFormat:@"%@", [format stringFromDate:x.reminder]];
    } else {
      // cell.dueDate.text = [format stringFromDate:x.created];
    }

    // cell.listName.text = currentList.title; //@"Shopping";

    cell.taskTitle.text = x.title;
    cell.listName.text =
        currentList
            .title; // [NSString stringWithFormat:@"%@ - %@", x.title, state];

    cell.task = currentTask;
    cell.cellPath = indexPath;
    cell.delegate = self;

    cell.deleteTask = ^{
      // [self deleteTask:x AtIndexPath:indexPath];
    };

    cell.completeTask = ^{
      //[self completeTask:x AtIndexPath:indexPath];
    };

  } else {
    cell.backgroundColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].primary;

    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = //[UIColor redColor].CGColor;
        [[SnowAppearanceManager sharedInstance] currentTheme].primary.CGColor;

    cell.textLabel.text = x.title;

    if (x.reminder) {
      cell.detailTextLabel.text = [NSString
          stringWithFormat:@"added %@ due on %@  repeat %@",
                           [format stringFromDate:x.created],
                           [format stringFromDate:x.reminder], x.repeat];
    } else {
      cell.detailTextLabel.text = [format stringFromDate:x.created];
    }

    cell.textLabel.textColor = [UIColor whiteColor];
    //    [UIColor colorWithHue:0.48 saturation:0.0 brightness:0.95
    //    alpha:1.0];

    cell.detailTextLabel.textColor = [UIColor whiteColor];
    //[UIColor colorWithHue:0.48 saturation:0.25 brightness:1.0 alpha:0.8];

    cell.textLabel.font =
        [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:22];
    //[UIFont systemFontOfSize:16.0 weight:4.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0 weight:1.0];

    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
  }
}

#pragma mark - SnowTaskDetailTVCDelegate

- (void)popDetail {
  [self.navigationController popViewControllerAnimated:YES];
  //[self reload];
}

- (void)deleteTask:(SnowTask *)task AtIndexPath:(NSIndexPath *)indexPath {
  task.deleted = YES;

  [[SnowDataManager sharedInstance]
                 updateTask:task
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks){

      }];

  [self updateTableActionsFor:task AtIndex:indexPath];
}

- (void)updateTableActionsFor:(SnowTask *)task
                      AtIndex:(NSIndexPath *)indexPath {

  // ==== Cache data update ===========//

  NSMutableArray *tmpTaskArray = [NSMutableArray new];

  SnowList *tmpList = [[_listManager fetchLists]
      objectAtIndex:indexPath.section]; //[_listTableSorted
  // objectAtIndex:indexPath.section];

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

  //==========  Remove notifications ========//

  [[SnowNotificationManager sharedInstance]
      unscheduleNotificationWithTask:task];

  // at the end

  // ===== Reload table, refresh cache  & take care of empty sections

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC),
                 dispatch_get_main_queue(), ^{
                   [self reload];
                 });
}

- (void)completeTask:(SnowTask *)task AtIndexPath:(NSIndexPath *)indexPath {
  task.completed = YES;
  task.completionDate = [NSDate date];

  [[SnowDataManager sharedInstance]
                 updateTask:task
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks){

      }];

  [self updateTableActionsFor:task AtIndex:indexPath];
}

- (void)cell:(SnowCardA2 *)cell
    ActionButtonPressedFor:(SnowTask *)task
                   AtIndex:(NSIndexPath *)index {

  UIAlertController *ac = [UIAlertController
      alertControllerWithTitle:@"Task"
                       message:task.title
                preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction *ac1 =
      [UIAlertAction actionWithTitle:@"complete"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {

                               [self completeTask:task AtIndexPath:index];

                             }];

  UIAlertAction *ac2 =
      [UIAlertAction actionWithTitle:@"delete"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {

                               [self deleteTask:task AtIndexPath:index];

                             }];

  UIAlertAction *ac3 =
      [UIAlertAction actionWithTitle:@"cancel"
                               style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction *action){

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

#pragma mark - add task

- (void)doThat:(id)sender {
  // UIStoryboard *storyBoard =
  //  [UIStoryboard storyboardWithName:@"Main" bundle:nil]; // self.storyboard;

  SnowTaskCreateTVC *createTaskVC =
      [[SnowTaskCreateTVC alloc] initWithStyle:UITableViewStyleGrouped];

  [_listTable objectForKey:[[_listTable allKeys] firstObject]];

  createTaskVC.selectedList = _list; //[_listManager defaultList];

  //[_listTable objectForKey:[[_listTable allKeys] firstObject]];

  [createTaskVC populateVC];

  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:createTaskVC];

  // self.definesPresentationContext = YES;

  nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

  [self presentViewController:nav
                     animated:YES
                   completion:^{

                     createTaskVC.saveTask = ^(SnowTask *item) {

                       [[SnowDataManager sharedInstance]
                                        saveTask:item
                           WithCompletionHandler:^(NSError *error,
                                                   NSDictionary *task){
                           }];

                       // [self reload];

                     };

                     // [createTaskVC populateVC];

                   }];
}

@end
