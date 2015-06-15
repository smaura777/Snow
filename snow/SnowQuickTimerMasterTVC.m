//
//  SnowQuickTimerMasterTVC.m
//  snow
//
//  Created by samuel maura on 5/21/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowQuickTimerMasterTVC.h"

@interface SnowQuickTimerMasterTVC ()

@end

@implementation SnowQuickTimerMasterTVC

- (void)close:(id)sender {
  [_delegate closeTimerView];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];

  self.tableView.rowHeight = 60;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(close:)];

  _timers = [NSMutableArray new];

  int step = 0;

  for (int i = 0; i < 9; i++) {

    SnowTimer *t = [[SnowTimer alloc] init];
    step += 5;
    t.timerValue = step * 60;
    t.timerName = [NSString stringWithFormat:@"%d ", step];
    [_timers addObject:t];
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  SnowTimer *t = [_timers objectAtIndex:indexPath.row];

  SnowQuickTimerDetailVC *detail = [[SnowQuickTimerDetailVC alloc] init];
  detail.timer = t;
  [self.navigationController pushViewController:detail animated:NO];
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
  return [_timers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"basic"
                                      forIndexPath:indexPath];

  // Configure the cell...
  cell.textLabel.text = [[_timers objectAtIndex:indexPath.row] timerName];

  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

@end
