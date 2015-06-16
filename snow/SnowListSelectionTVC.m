//
//  SnowListSelectionTVC.m
//  snow
//
//  Created by samuel maura on 3/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowListSelectionTVC.h"

@interface SnowListSelectionTVC ()

@end

@implementation SnowListSelectionTVC

- (void)viewDidLoad {
  [super viewDidLoad];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  // self.tableView.backgroundColor =
  //     [UIColor colorWithRed:0.12 green:0.12 blue:0.12 alpha:1];

  [[SnowDataManager sharedInstance]
      fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {

        _allList = lists;

        if (_selectedList) {
          [self hightlightInitialSelectionWith:_selectedList];
        } else {
          [self hightlightInitialSelectionWith:[_allList firstObject]];
        }

        [self.tableView reloadData];

      }];
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
  return [_allList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"list_selection"
                                      forIndexPath:indexPath];

  SnowList *list = [_allList objectAtIndex:indexPath.row];
  cell.backgroundColor = [UIColor clearColor];
  cell.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  cell.textLabel.text = list.title;
  cell.textLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];

  if (_lastSelection && (_lastSelection.row == indexPath.row)) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

  UITableViewCell *currentCell;
  UITableViewCell *prevCell;

  if (_lastSelection && (_lastSelection.row == indexPath.row)) {
    return;
  }

  if (_lastSelection) {
    prevCell = [self.tableView cellForRowAtIndexPath:_lastSelection];
    prevCell.accessoryType = UITableViewCellAccessoryNone;
  }

  currentCell = [self.tableView cellForRowAtIndexPath:indexPath];

  if (currentCell.accessoryType == UITableViewCellAccessoryNone) {

    [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];

    _lastSelection = indexPath;
  }

  SnowList *item = [_allList objectAtIndex:_lastSelection.row];

  self.updateSelectedList(item);
}

- (void)hightlightInitialSelectionWith:(SnowList *)list {

  if (!list) {
    return;
  }

  NSUInteger row = 0;

  for (SnowList *item in _allList) {
    if ([item.itemID isEqualToString:list.itemID]) {
      NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
      _lastSelection = index;
      //[self.tableView reloadRowsAtIndexPaths:@[index]
      // withRowAnimation:UITableViewRowAnimationNone];

      return;
    }

    ++row;
  }
}

@end
