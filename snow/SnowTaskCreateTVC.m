//
//  SnowTaskCreateTVC.m
//  snow
//
//  Created by samuel maura on 3/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTaskCreateTVC.h"
#import "SnowListSelectionTVC.h"
#import "SnowReminderDateWidget.h"
#import "SnowReminderRepeatTableViewController.h"
#import "SnowTwoLabelCell.h"
#import "SimpleTextViewCell.h"
#import "SnowTaskPriority.h"
#import "SnowAppearanceManager.h"
#import "AppDelegate.h"

@interface SnowTaskCreateTVC ()

@end

@implementation SnowTaskCreateTVC {
  BOOL _isReminderEnabled;
  BOOL _firstLoad;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self updateAnalyticsWithScreen:@"Create Task Screen"];

  _firstLoad = YES;

  AppDelegate *app =
      (AppDelegate *)[[UIApplication sharedApplication] delegate];
  app.topVC = self;

  self.title = @"Add a task";

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];

  [self.tableView registerClass:[SnowTwoLabelCell class]
         forCellReuseIdentifier:@"two_label_cell"];

  [self.tableView registerClass:[SimpleTextViewCell class]
         forCellReuseIdentifier:@"textview_cell"];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                           target:self
                           action:@selector(saveAction:)];

  self.navigationItem.leftBarButtonItem =
      [[UIBarButtonItem alloc] initWithImage:self.closeBt
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(cancelAction:)];

  // repeat frequency

  if (_editModeOn == YES) {
    if ([_taskToEdit.repeat isEqualToString:@"daily"]) {
      _repeatFrequency = NSCalendarUnitDay;
    } else if ([_taskToEdit.repeat isEqualToString:@"monthly"]) {
      _repeatFrequency = NSCalendarUnitMonth;

    } else if ([_taskToEdit.repeat isEqualToString:@"weekly"]) {
      _repeatFrequency = NSCalendarUnitWeekday;

    } else if ([_taskToEdit.repeat isEqualToString:@"yearly"]) {
      _repeatFrequency = NSCalendarUnitYear;
    } else if ([_taskToEdit.repeat isEqualToString:@"none"]) {
      _repeatFrequency = 0;
    }

    if (_taskToEdit.reminder) {
      _isReminderEnabled = YES;
    }
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tableView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  if (_isReminderEnabled) {
    return 5;
  } else {
    return 4;
  }
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
    return 1;
    break;
  case 3: {
    if (_isReminderEnabled) {
      return 2;
    } else {
      return 1;
    }
  } break;
  case 4:
    return 1;
    break;
  default:
    return 0;
    break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {

  switch (section) {
  case 0:
    return 0.5;
    break;
  default:
    return 40; // UITableViewAutomaticDimension;
    break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  switch (section) {
  case 0:
    return 0.5;
    break;

  default:
    return 40;
    break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  static NSDateFormatter *format;
  format = [[NSDateFormatter alloc] init];
  format.dateStyle = NSDateFormatterShortStyle;
  format.timeStyle = NSDateFormatterShortStyle;

  /*
  if (indexPath.section == 0) {
    cell = (SimpleTextViewCell*)
        [tableView dequeueReusableCellWithIdentifier:@"textview_cell"
                                        forIndexPath:indexPath];

  } else if (indexPath.section == 1) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"basic"
                                           forIndexPath:indexPath];
  } else {
    cell = (SnowTwoLabelCell*)
        [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                        forIndexPath:indexPath];
  }

  */

  switch (indexPath.section) {
  case 0:
    cell = (SimpleTextViewCell *)
        [tableView dequeueReusableCellWithIdentifier:@"textview_cell"
                                        forIndexPath:indexPath];
    break;
  case 1:
    cell = [tableView dequeueReusableCellWithIdentifier:@"basic"
                                           forIndexPath:indexPath];
    break;
  case 2:
    cell = (SnowTwoLabelCell *)
        [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                        forIndexPath:indexPath];

    break;
  case 3: {
    if (_isReminderEnabled) {
      cell = (SnowTwoLabelCell *)
          [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                          forIndexPath:indexPath];
    } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"basic"
                                             forIndexPath:indexPath];
    }

  }

  break;
  case 4: {
    cell = [tableView dequeueReusableCellWithIdentifier:@"basic"
                                           forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  } break;
  default:
    break;
  }

  // Configure the cell...

  cell.backgroundColor =
      [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:.7];

  // cell.textLabel.textColor = [UIColor whiteColor];

  switch (indexPath.section) {
  case 0: {
    SimpleTextViewCell *simpleTextViewCell = (SimpleTextViewCell *)cell;
    simpleTextViewCell.textView.delegate = self;
    simpleTextViewCell.textView.text = _taskTitle;
    simpleTextViewCell.textView.returnKeyType = UIReturnKeyDone;

    [simpleTextViewCell.textView sizeToFit];
    if (_firstLoad == YES) {
      [simpleTextViewCell.textView becomeFirstResponder];
      _firstLoad = NO;
    }

  } break;

  case 1: {
    cell.textLabel.text = _listTitle;
    cell.textLabel.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].primary;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  } break;

  case 2: {
    SnowTwoLabelCell *twoLabelCell = (SnowTwoLabelCell *)cell;
    twoLabelCell.title.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].primary;
    twoLabelCell.title.text = @"Priority";
    NSString *priorityString;

    switch ([_taskPriority integerValue]) {
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
    twoLabelCell.value.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].primary;

    //[NSString stringWithFormat:@"%d", [_taskPriority intValue]];
  } break;

  case 3: {
    if (_isReminderEnabled) {
      SnowTwoLabelCell *twoLabelCell = (SnowTwoLabelCell *)cell;
      twoLabelCell.title.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;
      twoLabelCell.value.textColor =
          [[SnowAppearanceManager sharedInstance] currentTheme].primary;

      if (indexPath.row == 0) {
        twoLabelCell.title.text = @"Reminder";

        if (_reminderDate) {
          twoLabelCell.value.text = [format stringFromDate:_reminderDate];
        } else {
          twoLabelCell.value.text = @"none";
        }

      } else {
        twoLabelCell.title.text = @"Repeat";
        twoLabelCell.value.text = _repeatFrequencyString;
      }
    } else {
      if (indexPath.row == 0) {
        UILabel *enableReminder = [[UILabel alloc] init];
        enableReminder.frame = cell.bounds;
        enableReminder.text = @"enable reminder";
        enableReminder.textAlignment = NSTextAlignmentCenter;
        enableReminder.textColor =
            [[SnowAppearanceManager sharedInstance] currentTheme].primary;
        // NSLog(@" subv count %ld", [[cell.contentView subviews] count]);
        if ([[cell.contentView subviews] count] > 0) {
          for (UIView *v in [cell.contentView subviews]) {
            [v removeFromSuperview];
          }
        }
        // NSLog(@" subv count %ld", [[cell.contentView subviews] count]);
        [cell.contentView addSubview:enableReminder];

        // cell.textLabel.text = @"enable reminder";
        // cell.textLabel.textColor = [UIColor whiteColor];
      }
    }

  } break;

  case 4: {
    // cell = nil;
    // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
    // reuseIdentifier:@"none"];
    UILabel *disableReminder = [[UILabel alloc] init];
    disableReminder.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].primary;
    disableReminder.frame = cell.bounds;
    disableReminder.text = @"disable reminder";
    disableReminder.textAlignment = NSTextAlignmentCenter;
    // disableReminder.textColor = [UIColor whiteColor];
    // NSLog(@" subv count %ld", [[cell.contentView subviews] count]);
    if ([[cell.contentView subviews] count] > 0) {
      for (UIView *v in [cell.contentView subviews]) {
        [v removeFromSuperview];
      }
    }
    // NSLog(@" subv count %ld", [[cell.contentView subviews] count]);

    [cell.contentView addSubview:disableReminder];

    // cell.textLabel.text = @"Disable reminder";
    // cell.textLabel.textColor = [UIColor whiteColor];
    // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } break;

  default:
    // NSLog(@"hit default");
    break;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

  if ((indexPath.section == 1) && (indexPath.row == 0)) {
    [self changeListAction:nil];
  } else if (indexPath.section == 2) {
    [self priorityTapped:nil];
  } else if ((indexPath.section == 3) && (indexPath.row == 0)) {
    if (_isReminderEnabled) {
      [self reminderTapped:nil];
    } else {
      _isReminderEnabled = !_isReminderEnabled;
      [self toggleReminderSettings];
      [self.tableView reloadData];
    }

  } else if ((indexPath.section == 3) && (indexPath.row == 1)) {
    [self reminderRepeatTapped:nil];
  } else if (indexPath.section == 4) {
    _isReminderEnabled = !_isReminderEnabled;
    [self toggleReminderSettings];
    [self.tableView reloadData];
  }
}

#pragma mark - tableviewdelegate

- (void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
               forSection:(NSInteger)section {
  UITableViewHeaderFooterView *head = (UITableViewHeaderFooterView *)view;
  head.textLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  NSString *taskName;
  switch (section) {
  case 0:
    taskName = @"";
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

  return taskName;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 100;
  }

  return 45;
}

#pragma mark - tap actions

- (IBAction)saveAction:(id)sender {
  int dateChangeCount = 0;

  if (!_selectedList) {
    // NSLog(@"No List selected "); // Should never be feasible
    return;
  }

  if ([_taskTitle length] == 0) {
    return; // disable save button
  }

  if (_editModeOn == YES) {
    _taskToEdit.title = _taskTitle;
    _taskToEdit.listID = _selectedList.itemID;
    _taskToEdit.priority = _taskPriority;

    if (_reminderDate) {
      if (_dateHasChanged) {
        _taskToEdit.reminder = _reminderDate;
        ++dateChangeCount;
      }

      if (_frequencyHasChanged) {
        _taskToEdit.repeat = _repeatFrequencyString;
        ++dateChangeCount;
      }

      if (dateChangeCount > 0) {
        [[SnowNotificationManager sharedInstance]
            scheduleNotificationWithTask:_taskToEdit];
      }

    } else {
      _taskToEdit.reminder = nil;
      _taskToEdit.repeat = @"none";
      // Cancel existing notifications if any
      [[SnowNotificationManager sharedInstance]
          unscheduleNotificationWithTask:_taskToEdit];
    }

    self.updateTask(_taskToEdit);

  } else { // New task

    SnowTask *newTask = [SnowTask new];
    newTask.title = _taskTitle;
    newTask.listID = _selectedList.itemID;
    newTask.itemID = [[NSUUID UUID] UUIDString];
    newTask.priority = _taskPriority;

    if (_reminderDate) {
      newTask.reminder = _reminderDate;

      [[SnowNotificationManager sharedInstance]
          scheduleNotificationWithTask:newTask];

    } else {
      newTask.reminder = nil;
      newTask.repeat = @"none";
    }

    self.saveTask(newTask);
  }

  [self.parentViewController dismissViewControllerAnimated:YES
                                                completion:^{
                                                }];
}

- (IBAction)cancelAction:(id)sender {
  [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeListAction:(id)sender {
  // NSLog(@"Change list action....");
  // UIStoryboard* storyboard = self.storyboard;
  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];

  SnowListSelectionTVC *listSelectVC = (SnowListSelectionTVC *)
      [storyboard instantiateViewControllerWithIdentifier:@"list_select_sb"];

  listSelectVC.selectedList = _selectedList;

  [self.navigationController pushViewController:listSelectVC animated:YES];

  listSelectVC.updateSelectedList = ^(SnowList *item) {
    if (![_listTitle isEqualToString:item.title]) {
      _listTitle = item.title;
      _selectedList = item;
      [self.navigationController popViewControllerAnimated:YES];
      [self.tableView reloadData];
    }

  };
}

- (IBAction)reminderTapped:(id)sender {
    
    [[SnowNotificationManager sharedInstance] registerForLocalNotifications];

  static NSDateFormatter *format;

  format = [[NSDateFormatter alloc] init];

  format.dateStyle = NSDateFormatterShortStyle;
  format.timeStyle = NSDateFormatterShortStyle;

  // NSLog(@"Set a reminder tappeed ");

  // NSLog(@"Change list action....");
  // UIStoryboard* storyboard = self.storyboard;

  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];

  SnowReminderDateWidget *rdw = (SnowReminderDateWidget *)[storyboard
      instantiateViewControllerWithIdentifier:@"reminder_widget_sb"];

  if (_taskToEdit) {
    rdw.currentReminder = _reminderDate;
  }

  rdw.reminderChanged = ^(NSDate *item) {
    // NSLog(@"Something Changed...%@ \n\n", [item description]);

    if (![_reminderDate isEqualToDate:item]) {
      _dateHasChanged = YES;
      _reminderDate = item;
      // NSLog(@"New reminder date older than previous one ");
      [self.tableView reloadData];
    }

  };

  [self.navigationController pushViewController:rdw animated:YES];
}

- (IBAction)reminderRepeatTapped:(id)sender {
    [[SnowNotificationManager sharedInstance] registerForLocalNotifications];
    
  NSArray *repeatOptions =
      @[ @"none", @"daily", @"weekly", @"monthly", @"yearly" ];

  // UIStoryboard* storyboard = self.storyboard;

  UIStoryboard *storyboard =
      [UIStoryboard storyboardWithName:@"Main" bundle:nil];

  SnowReminderRepeatTableViewController *rdw =
      (SnowReminderRepeatTableViewController *)[storyboard
          instantiateViewControllerWithIdentifier:@"reminder_repeat_sb"];

  if (_taskToEdit.repeat) {
    rdw.currentFrequency = _taskToEdit.repeat;
  }

  rdw.repeatSelected = ^(NSInteger item) {
    // NSLog(@"Something Changed repeat every ...%ld", item);

    _repeatFrequencyString = [repeatOptions objectAtIndex:item];

    switch (item) {
    case 0:
      _repeatFrequency = 0;
      break;
    case 1:
      _repeatFrequency = NSCalendarUnitDay;
      break;

    case 2:
      _repeatFrequency = NSCalendarUnitWeekday;
      break;

    case 3:
      _repeatFrequency = NSCalendarUnitMonth;
      break;
    case 4:
      _repeatFrequency = NSCalendarUnitYear;
      break;

    default:
      _repeatFrequency = 0;
      break;
    }

    if (![_repeatFrequencyString isEqualToString:_taskToEdit.repeat]) {
      _frequencyHasChanged = YES;
      [self.navigationController popViewControllerAnimated:YES];
      [self.tableView reloadData];
    }

  };

  [self.navigationController pushViewController:rdw animated:YES];
}

- (void)priorityTapped:(id)sender {
  SnowTaskPriority *taskPriority =
      [[SnowTaskPriority alloc] initWithStyle:UITableViewStylePlain];

  taskPriority.initialPriority = [_taskPriority intValue];

  taskPriority.updatePriority = ^(int item) {
    _taskPriority = [NSNumber numberWithInt:item];
    [self.tableView reloadData];

  };

  [self.navigationController pushViewController:taskPriority animated:YES];
}

#pragma mark -  UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
  // NSLog(@"TEXTVIEW EDITING ENDED ...");
  if ([textView.text length] > 0) {
    //_taskTitle = textView.text;
  }

  // NSLog(@"%s", __func__);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
  // NSLog(@"%s", __func__);
  return YES;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([text length] > 0) {
    unichar last = [text characterAtIndex:0];
    if ([[NSCharacterSet newlineCharacterSet] characterIsMember:last]) {
      // NSLog(@"Got a newline character ...");
      [textView resignFirstResponder];
    }
    //_taskTitle = textView.text ;
  }

  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  if ([textView.text length] > 0) {
    _taskTitle =
        [textView.text stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
  }

  // NSLog(@"%s", __func__);
}

- (void)toggleReminderSettings {
  if (!_isReminderEnabled) {
    _repeatFrequencyString = @"no";
    _repeatFrequency = 0;
    _reminderDate = nil;
  } else {
    [[SnowNotificationManager sharedInstance] registerForLocalNotifications];
  }
}

- (void)populateVC {
  static NSDateFormatter *format;

  format = [[NSDateFormatter alloc] init];

  format.dateStyle = NSDateFormatterShortStyle;
  format.timeStyle = NSDateFormatterShortStyle;

  if (_taskToEdit) {
    _taskTitle = _taskToEdit.title;

    if (_selectedList) {
      _listTitle = _selectedList.title;
    }

    if (_taskToEdit.reminder) {
      _reminderDate = _taskToEdit.reminder;
    }

    // Priority
    if (_taskToEdit.priority) {
      _taskPriority = _taskToEdit.priority;
    }

    if (_taskToEdit.repeat) {
      _repeatFrequencyString = _taskToEdit.repeat;
    }

    if ([_taskToEdit.repeat isEqualToString:@"daily"]) {
      _repeatFrequency = NSCalendarUnitDay;
    } else if ([_taskToEdit.repeat isEqualToString:@"monthly"]) {
      _repeatFrequency = NSCalendarUnitMonth;

    } else if ([_taskToEdit.repeat isEqualToString:@"weekly"]) {
      _repeatFrequency = NSCalendarUnitWeekday;

    } else if ([_taskToEdit.repeat isEqualToString:@"yearly"]) {
      _repeatFrequency = NSCalendarUnitYear;
    } else {
      _repeatFrequency = 0;
    }

  } else {
    _taskTitle = @"";
    if (_selectedList) {
      _listTitle = _selectedList.title;
    } else {
      _listTitle = @"";
    }
    _reminderDate = nil;
    _repeatFrequency = 0;
    _repeatFrequencyString = @"no";
    _taskPriority = [NSNumber numberWithInt:0];
  }

  _firstLoad = YES;
  [self.tableView reloadData];
}

@end
