//
//  SnowReminderRepeatTableViewController.m
//  snow
//
//  Created by samuel maura on 4/3/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowReminderRepeatTableViewController.h"

@interface SnowReminderRepeatTableViewController ()

@end

@implementation SnowReminderRepeatTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  [self updateRepeatOptions];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tableView.backgroundColor =
      [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [_repeatOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"repeat_option_cell"
                                      forIndexPath:indexPath];

  // Configure the cell...

  cell.backgroundColor = [UIColor clearColor];
  cell.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
  cell.textLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  cell.textLabel.text = [_repeatOptions objectAtIndex:indexPath.row];

  if (_selectedOption == indexPath.row) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  /**

  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

  if (indexPath.row != _selectedOption){
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  else {
      cell.accessoryType = UITableViewCellAccessoryNone;
  }

  **/

  _selectedOption = indexPath.row;

  self.repeatSelected(_selectedOption);

  [self.tableView reloadData];
}

#pragma mark - setup metods
- (void)updateRepeatOptions {
  _repeatOptions = @[
    @"Never",
    @"Every Day",
    @"Every Week",
    @"Every Month",
    @"Every Year"
  ];

  if (_currentFrequency) {
    if ([_currentFrequency isEqualToString:@"none"]) {
      _selectedOption = 0;
    } else if ([_currentFrequency isEqualToString:@"daily"]) {
      _selectedOption = 1;
    } else if ([_currentFrequency isEqualToString:@"weekly"]) {
      _selectedOption = 2;
    } else if ([_currentFrequency isEqualToString:@"monthly"]) {
      _selectedOption = 3;
    } else if ([_currentFrequency isEqualToString:@"yearly"]) {
      _selectedOption = 4;
    }
  }
}

@end
