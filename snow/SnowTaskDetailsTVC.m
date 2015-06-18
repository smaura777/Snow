//
//  SnowTaskDetailsTVC.m
//  snow
//
//  Created by samuel maura on 5/8/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTaskDetailsTVC.h"
#import "SnowButtonCell.h"
#import "SnowTwoLabelCell.h"
#import "SnowTaskCreateTVC.h"

@interface SnowTaskDetailsTVC ()

@end

@implementation SnowTaskDetailsTVC {
  UIView *_taskHeadline;
  UILabel *_taskHeadlineLabel;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self updateAnalyticsWithScreen:@"Task detail Screen"];

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];

  [self.tableView registerClass:[SnowButtonCell class]
         forCellReuseIdentifier:@"button_cell"];

  [self.tableView registerClass:[SnowTwoLabelCell class]
         forCellReuseIdentifier:@"two_label_cell"];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.

  // Edit only enabled for active tasks
  if ((!_detailTask.completed) && (!_detailTask.deleted)) {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                             target:self
                             action:@selector(doEdit:)];
  }

  // self.tableView.contentOffset   = CGPointMake(100, 200);
  // //UIEdgeInsetsMake(100, 0, 0, 0);

  // Cell sizing

  // self.tableView.rowHeight = UITableViewAutomaticDimension;
  // self.tableView.estimatedRowHeight = 100.0;

  /*
  [UIView setAnimationsEnabled:NO];
  self.navigationItem.prompt = @"\t";
  [UIView setAnimationsEnabled:YES];
  */

  CGRect wrapperFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 200);

  _taskHeadline = [[UIView alloc] initWithFrame:wrapperFrame];
  _taskHeadline.backgroundColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  _taskHeadlineLabel = [[UILabel alloc] initWithFrame:wrapperFrame];
  _taskHeadlineLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;
  _taskHeadlineLabel.textAlignment = NSTextAlignmentCenter;
  _taskHeadlineLabel.numberOfLines = 0;

  _taskHeadlineLabel.font =
      [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:24];
  _taskHeadlineLabel.text = _detailTask.title;
  [_taskHeadline addSubview:_taskHeadlineLabel];
/*
  CGSize textSize = [_detailTask.title sizeWithAttributes:@{
    NSFontAttributeName :
        [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:28]
  }];
*/
  // NSLog(@"TEXT HEIGHT %lg", textSize.height);

  CGSize adSize = CGSizeMake(_taskHeadline.bounds.size.width, 200);

  _taskHeadline.frame = CGRectMake(0, 0, adSize.width, adSize.height);
  _taskHeadlineLabel.frame = CGRectInset(_taskHeadline.frame, 4, 8);
  // CGRectMake(0, 0, adSize.width, adSize.height);

  self.tableView.tableHeaderView = _taskHeadline;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.tableView.backgroundColor =
      [UIColor colorWithRed:.90 green:.90 blue:.90 alpha:1];

  _taskHeadlineLabel.text = _detailTask.title;
  //[self applyTheme];
}

/*
- (void)viewDidLayoutSubviews {


  CGSize textSize = [_detailTask.title sizeWithAttributes:@{
    NSFontAttributeName :
        [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:28]
  }];

  //NSLog(@"TEXT HEIGHT %lg", textSize.height);

  CGSize adSize =
      CGSizeMake(_taskHeadline.bounds.size.width, textSize.height + 100);

  self.tableView.tableHeaderView.frame = CGRectMake(0, 0, adSize.width,
adSize.height);
  _taskHeadline.frame = CGRectMake(0, 0, adSize.width, adSize.height);

  _taskHeadlineLabel.frame = CGRectMake(0, 0, adSize.width, adSize.height);




}
*/

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)hideSearchBar {
  // self.tableView.contentOffset = CGPointMake(0, 60);
  // self.edgesForExtendedLayout = UIRectEdgeBottom;
}

/*
- (void)viewDidLayoutSubviews {
  [self hideSearchBar];
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 5;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.

  switch (section) {
  case 0:
    return 1;
    break;
  case 1:
    return 1;
    break;
  case 2:
    return 2;
    break;
  case 3:
    return 1;
    break;
  case 4:
    return 1;
    break;
  default:
    return 0;
    break;
  }

  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  static NSDateFormatter *format;
  format = [[NSDateFormatter alloc] init];
  format.dateStyle = NSDateFormatterShortStyle;
  format.timeStyle = NSDateFormatterShortStyle;

  switch (indexPath.section) {
  case 0:
    cell = [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                           forIndexPath:indexPath];
    break;
  case 1:
  case 2:
    cell = (SnowTwoLabelCell *)
        [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                        forIndexPath:indexPath];
    break;
  case 3:
  case 4:
    cell = (SnowButtonCell *)
        [tableView dequeueReusableCellWithIdentifier:@"button_cell"
                                        forIndexPath:indexPath];
    break;

  default:
    break;
  }

  cell.selectionStyle = UITableViewCellSelectionStyleNone;

  // Configure the cell...

  if (_detailTask) {

    cell.backgroundColor =
        [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:0];
    //[[SnowAppearanceManager sharedInstance] currentTheme].primary;

    cell.textLabel.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].primary;

    //[[SnowAppearanceManager sharedInstance] currentTheme].textColor;

    switch (indexPath.section) {
    /*
        case 0: {
      cell.textLabel.numberOfLines = 0;
      cell.contentView.frame = CGRectMake(
          cell.contentView.frame.origin.x, cell.contentView.frame.origin.y,
          cell.contentView.bounds.size.width, 280);
      cell.textLabel.text = _detailTask.title;

    } break;
*/
    case 0: {
      SnowTwoLabelCell *twoLabelCell = (SnowTwoLabelCell *)cell;
      twoLabelCell.title.text = @"List";
      twoLabelCell.value.text = _parentList.title;

      twoLabelCell.title.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;
      twoLabelCell.value.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;

      /*
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = _parentList.title;
       */

    } break;

    case 1: {
      SnowTwoLabelCell *twoLabelCell = (SnowTwoLabelCell *)cell;
      twoLabelCell.title.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;
      twoLabelCell.value.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;

      twoLabelCell.title.text = @"Priority";

      NSString *priorityString;

      switch ([_detailTask.priority integerValue]) {
      case 0:
        priorityString = @"low";
        break;
      case 1:
        priorityString = @"medium";
        break;
      case 2:
        priorityString = @"high";
        break;
      default:
        priorityString = @"";
        break;
      }

      twoLabelCell.value.text = priorityString;

      // [NSString stringWithFormat:@"%d", [_detailTask.priority intValue]];

    } break;

    case 2: {
      SnowTwoLabelCell *twoLabelCell = (SnowTwoLabelCell *)cell;
      twoLabelCell.title.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;
      twoLabelCell.value.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;

      if (indexPath.row == 0) {
        if (_detailTask.reminder) {
          twoLabelCell.title.text = @"Reminder";
          twoLabelCell.value.text =
              [format stringFromDate:_detailTask.reminder];

        } else {
          twoLabelCell.title.text = @"Reminder";
          twoLabelCell.value.text = @"none";
        }

      } else {
        if ([_detailTask.repeat isEqualToString:@"none"]) {
          twoLabelCell.title.text = @"Repeat";
          twoLabelCell.value.text = @"no";

        } else {
          twoLabelCell.title.text = @"Repeat";
          twoLabelCell.value.text = _detailTask.repeat;
        }
      }

    } break;

    case 3: {

      SnowButtonCell *buttonCell = (SnowButtonCell *)cell;

      if (_detailTask.completed || _detailTask.deleted) {

        [buttonCell.button addTarget:self
                              action:@selector(doUnarchive)
                    forControlEvents:UIControlEventTouchUpInside];
        [buttonCell.button setTitle:@"unarchive" forState:UIControlStateNormal];
      } else {

        [buttonCell.button addTarget:self
                              action:@selector(doComplete:)
                    forControlEvents:UIControlEventTouchUpInside];
        [buttonCell.button setTitle:@"complete" forState:UIControlStateNormal];
      }

      [buttonCell.button
          setTitleColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                            .primary
               forState:UIControlStateNormal];

    }

    break;

    case 4: {
      // cell.backgroundColor = [UIColor clearColor];
      SnowButtonCell *buttonCell = (SnowButtonCell *)cell;

      if (_detailTask.completed || _detailTask.deleted) {

        [buttonCell.button addTarget:self
                              action:@selector(doClear)
                    forControlEvents:UIControlEventTouchUpInside];

        [buttonCell.button setTitle:@"clear" forState:UIControlStateNormal];

      } else {
        [buttonCell.button addTarget:self
                              action:@selector(doDelete:)
                    forControlEvents:UIControlEventTouchUpInside];

        [buttonCell.button setTitle:@"delete" forState:UIControlStateNormal];
      }

      [buttonCell.button setTitleColor:[UIColor redColor]
                              forState:UIControlStateNormal];

    } break;

    default:
      break;
    }
  }
  return cell;
}

#pragma mark - tableviewdelegate

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  NSString *taskName;
  switch (section) {
  case 0:
    taskName = @"Task";
    break;
  case 1:
    taskName = @"List";
    break;
  case 2:
    taskName = @"Priority";
    break;
  case 3:
    taskName = @"Reminder";
    break;

  default:
    taskName = @"";
    break;
  }

  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  switch (section) {
  case 4:
  case 5:
    return 10;
    break;
  default:
    return 5;
    break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  return 5.0;
}

- (void)doEdit:(id)sender {

  if (_detailTask.completed || _detailTask.deleted) {
    return;
  }

  // NSLog(@"DO EDIT ...");

  SnowTaskCreateTVC *createTaskVC =
      [[SnowTaskCreateTVC alloc] initWithStyle:UITableViewStyleGrouped];
  createTaskVC.selectedList = _parentList;

  createTaskVC.taskToEdit = _detailTask;
  createTaskVC.editModeOn = YES;
  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:createTaskVC];

  nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

  [self
      presentViewController:nav
                   animated:YES
                 completion:^{
                   createTaskVC.saveTask = ^(SnowTask *item) {
                   };

                   createTaskVC.updateTask = ^(SnowTask *item) {

                     [[SnowDataManager sharedInstance]
                                    updateTask:item
                         WithCompletionHandler:^(NSError *error,
                                                 NSDictionary *task) {
                           // Grad updated task from list

                           NSArray *listNames = [task allKeys];

                           for (NSString *listname in listNames) {

                             SnowList *list = [task objectForKey:listname];

                             if ([list.itemID
                                     isEqualToString:_parentList.itemID]) {
                               for (SnowTask *task in list.tasklist) {
                                 if ([task.itemID
                                         isEqualToString:_detailTask.itemID]) {
                                   _detailTask = task;
                                   [self.tableView reloadData];
                                   return;
                                 }
                               }
                             }
                           }

                         }];

                   };

                   [createTaskVC populateVC];

                 }];
}

- (void)doClear {

  [[SnowDataManager sharedInstance]
                 removeTask:_detailTask
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks) {

        // NSLog(@"Clear operation completed for task ");
        [_delegate popDetail];

      }];
}

- (void)doUnarchive {

  _detailTask.completed = 0;
  _detailTask.deleted = 0;
  _detailTask.completionDate = nil;
  BOOL shouldRescheduleReminder = NO;

  if (_detailTask.reminder != nil) {
    if ([[NSDate date] timeIntervalSince1970] <
        [_detailTask.reminder timeIntervalSince1970]) {
      // Re-enable reminder
      shouldRescheduleReminder = YES;
    } else {
      _detailTask.reminder = nil;
      _detailTask.repeat = @"none";
    }
  }

  [[SnowDataManager sharedInstance]
                 updateTask:_detailTask
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks) {
        // NSLog(@"Task was reset successfullly");

        if (shouldRescheduleReminder) {
          [[SnowNotificationManager sharedInstance]
              scheduleNotificationWithTask:_detailTask];
        }

        [_delegate popDetail];

      }];
}

- (void)doComplete:(id)sender {
  // NSLog(@"DO DELETE ...");
  _detailTask.completed = YES;

  [[SnowDataManager sharedInstance]
                 updateTask:_detailTask
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks) {
        // NSLog(@"Delete operation completed for task ");

        if (error) {
          // NSLog(@"Failed updated %s", __FUNCTION__);
        }

      }];

  [_delegate popDetail];
}

- (void)doDelete:(id)sender {
  // NSLog(@"DO DELETE ...");
  _detailTask.deleted = YES;

  [[SnowDataManager sharedInstance]
                 updateTask:_detailTask
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks) {
        // NSLog(@"Delete operation completed for task ");

        if (error) {
          // NSLog(@"Failed updated %s", __FUNCTION__);
        }

      }];

  [_delegate popDetail];
}

@end
