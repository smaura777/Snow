//
//  SnowTaskPriority.m
//  snow
//
//  Created by samuel maura on 5/14/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTaskPriority.h"

@interface SnowTaskPriority ()

@end

@implementation SnowTaskPriority {
  UITableViewCell *_checkedCell;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self updateAnalyticsWithScreen:@"Task priority selection Screen"];

  _selectedPriority = _initialPriority;
  _priorities = @[ @"low", @"medium", @"high" ];

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];
  /*
    self.tableView.backgroundColor =
        [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];
  */
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
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return [_priorities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"basic"
                                      forIndexPath:indexPath];

  cell.backgroundColor = [UIColor clearColor];
  cell.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];
  cell.textLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  // Configure the cell...
  cell.textLabel.text = [_priorities objectAtIndex:indexPath.row];
  if (_selectedPriority == indexPath.row) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _checkedCell = cell;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
  UITableViewCell *selectedCell =
      [self.tableView cellForRowAtIndexPath:indexPath];

  _selectedPriority = (int)indexPath.row;

  if (_checkedCell != selectedCell) {
    _checkedCell.accessoryType = UITableViewCellAccessoryNone;
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
  }

  _checkedCell = selectedCell;

  self.updatePriority(_selectedPriority);
}

@end
