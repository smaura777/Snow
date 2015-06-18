//
//  SnowSearchResultsTVC.m
//  snow
//
//  Created by samuel maura on 5/20/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowSearchResultsTVC.h"

@interface SnowSearchResultsTVC ()

@end

@implementation SnowSearchResultsTVC {
  SnowListManager *_listManager;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.tableView registerClass:[SnowCardA3 class]
         forCellReuseIdentifier:@"snow_card_a3"];

  UINib *cellNIB = [UINib nibWithNibName:@"SnowCardA" bundle:nil];
  [self.tableView registerNib:cellNIB forCellReuseIdentifier:@"snow_card_a"];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100.0;

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"result"];
  /*
       UIBarButtonItem *drawer = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage
                                   imageNamed:@"snow_stack_filled-50"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                  action:@selector(toggleMenu:)];
    */

  // self.navigationItem.leftBarButtonItem = drawer;

  //_filteredResults = @[ @"e 1", @"e 2", @"e 3", @"e 5" ];

  _taskList = [NSArray new];

  _listManager = [SnowListManager new];

  [_listManager refresh];
  [_listManager refreshArchived];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  // [_listManager refresh];
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
  return [_taskList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  /*
UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"result"
                                    forIndexPath:indexPath];

// Configure the cell...
SnowTask *task = [_taskList objectAtIndex:indexPath.row];
cell.textLabel.text = task.title;
cell.detailTextLabel.text = @"TEST ";
*/

  SnowCardA3 *cell =
      [tableView dequeueReusableCellWithIdentifier:@"snow_card_a3"
                                      forIndexPath:indexPath];

  [self configCell:cell WithIdentifier:1 atIndexPath:indexPath];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  // [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  // SnowList *selectedList = [[_listManager fetchLists]
  // objectAtIndex:indexPath.section];

  SnowTask *selectedTask = [_taskList objectAtIndex:indexPath.row];

  [_delegate loadTask:selectedTask];

  /*
  SnowList *selectedList = [_listManager getListWithID:selectedTask.listID];

  SnowTaskDetailsTVC *details =
  [[SnowTaskDetailsTVC alloc] initWithStyle:UITableViewStyleGrouped];

  details.delegate = self;
  details.detailTask = selectedTask;
  details.parentList = selectedList;
  */

  //[self.navigationController pushViewController:details animated:YES];
}

- (void)configCell:(UITableViewCell *)cellIn
    WithIdentifier:(NSUInteger)identifier
       atIndexPath:(NSIndexPath *)indexPath {

  SnowList *currentList;

  SnowTask *currentTask = [_taskList objectAtIndex:indexPath.row];

  for (SnowList *it in [_listManager allLists]) {
    if ([[it itemID] isEqualToString:currentTask.listID]) {
      currentList = it;
      break;
    }
  }

  static NSDateFormatter *format = nil;

  if (format == nil) {
    format = [[NSDateFormatter alloc] init];
    format.dateStyle = NSDateFormatterShortStyle;
    format.timeStyle = NSDateFormatterShortStyle;
  }

  SnowTask *x = currentTask;
  SnowCardA3 *cell = (SnowCardA3 *)cellIn;

  if (identifier == 1) {

    cell.dataContainerView.backgroundColor =
        [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:1];

    cell.taskTitle.text = x.title;

    if (x.reminder) {
      cell.dueDate.text =
          [NSString stringWithFormat:@"%@", [format stringFromDate:x.reminder]];
    } else {
      // cell.dueDate.text = [format stringFromDate:x.created];
    }

    cell.listName.text = currentList.title; //@"Shopping";

    cell.deleteTask = ^{
      // [self deleteTask:x AtIndexPath:indexPath];
    };

    cell.completeTask = ^{
      //[self completeTask:x AtIndexPath:indexPath];
    };

    cell.task = currentTask;
    cell.cellPath = indexPath;

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

@end
