//
//  SnowListAllTVC.m
//  snow
//
//  Created by samuel maura on 4/6/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowListAllTVC.h"
#import "SnowDataManager.h"
#import "SnowNotificationManager.h"
#import "SnowTaskAllTVC.h"
#import "SnowTwoLabelCell.h"
#import "SnowListManager.h"
#import "SnowListCreateTVC.h"

@interface SnowListAllTVC ()

@end

@implementation SnowListAllTVC {
  SnowListManager *_listManager;
  NSMutableDictionary *_activeTaskCountPerList;
  BOOL _firstLoad;
  UILabel *_emptyLabel;
  NSString *_emptyMessage;
}

- (void)reload {

  // This gets all list - empty or not
  [[SnowDataManager sharedInstance]
      fetchListWithCompletionHandler:^(NSError *error, NSArray *lists) {
        if (lists) {
          _completeList = lists;
        }

      }];

  [_listManager refresh];

  [self updateListWithTasks];

  [self.tableView reloadData];
}

- (void)updateListWithTasks {

  _activeTaskCountPerList = [@{} mutableCopy];

  NSArray *_listWithTasks = [_listManager fetchLists];

  for (SnowList *i in _listWithTasks) {
    [_activeTaskCountPerList
        setObject:[NSNumber numberWithInteger:[i.tasklist count]]
           forKey:i.itemID];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _emptyMessage = @"No lists";
  _firstLoad = YES;

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];

  [self.tableView registerClass:[SnowTwoLabelCell class]
         forCellReuseIdentifier:@"two_label_cell"];

  UIBarButtonItem *drawer = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_menu_drawer"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(toggleMenu:)];

  self.navigationItem.leftBarButtonItem = drawer;

  UIBarButtonItem *item = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_bar_list"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(doIt:)];

  self.navigationItem.rightBarButtonItems = @[ item ];

  _completeList = [NSArray new];

  _listManager = [SnowListManager new];

  [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (!_firstLoad) {
    [self reload];
  }

  _firstLoad = NO;
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

  NSInteger section_count = [_completeList count];

  if (_emptyLabel == nil) {
    _emptyLabel = [[UILabel alloc] init];
  }

  [self showEmptyDataMessageIfNeeded:section_count
                             WithMsg:_emptyMessage
                            AndLabel:_emptyLabel];

  return section_count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  NSInteger taskCount = 0;

  SnowTwoLabelCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                      forIndexPath:indexPath];

  SnowList *list = [_completeList objectAtIndex:indexPath.row];

  NSNumber *obCount = [_activeTaskCountPerList objectForKey:list.itemID];
  if (obCount) {
    taskCount = [obCount integerValue];
  }

  cell.backgroundColor = [UIColor clearColor];

  cell.title.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  cell.title.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]; //[UIFont
  // fontWithName:@"AvenirNext-Medium"
  // size:20];

  cell.title.text = list.title;

  cell.value.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  cell.value.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

  /*
   cell.value.backgroundColor = [[SnowAppearanceManager sharedInstance]
   currentTheme].primary;
     cell.value.frame = CGRectMake(cell.value.frame.origin.x,
   cell.value.frame.origin.y, 100, 50);

     cell.value.layer.borderWidth = 1;
     cell.value.layer.borderColor = [[SnowAppearanceManager sharedInstance]
   currentTheme].primary.CGColor;
     cell.value.layer.cornerRadius = 10.0;
     cell.value.clipsToBounds =YES;
 */

  cell.value.text = [NSString stringWithFormat:@"%ld", taskCount];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

  SnowList *selectedList = [_completeList objectAtIndex:indexPath.row];

  SnowAllPendingTaskForList *taskForList =
      [[SnowAllPendingTaskForList alloc] initWithStyle:UITableViewStyleGrouped];

  taskForList.list = selectedList;

  [self.navigationController pushViewController:taskForList animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    SnowList *selectedList = [_completeList objectAtIndex:indexPath.row];

    // remove notifications
    [[SnowNotificationManager sharedInstance]
        unscheduleNotificationsWithList:selectedList];

    [[SnowDataManager sharedInstance]
                   removeList:selectedList
        WithCompletionHandler:^(NSError *error, NSArray *lists) {
          NSLog(@"list %@  deleted successfully ", selectedList.itemID);

          _completeList = lists;

          [tableView deleteRowsAtIndexPaths:@[ indexPath ]
                           withRowAnimation:UITableViewRowAnimationFade];

        }];

    [_listManager refresh];
    [self updateListWithTasks];

  } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array,
    // and add a new row to the table view
  }
}

- (void)toggleMenu:(id)sender {
  self.menuTapped();
}

#pragma mark-- add list
- (void)doIt:(id)sender {

  _firstLoad = YES; // Need this to prevent reload on viewwillappear - since we
                    // are taking care of it manually here

  SnowListCreateTVC *listCreationVC =
      [[SnowListCreateTVC alloc] initWithStyle:UITableViewStyleGrouped];
  UINavigationController *sl = [[UINavigationController alloc]
      initWithRootViewController:listCreationVC];

  sl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

  [self
      presentViewController:sl
                   animated:YES
                 completion:^{

                   SnowListCreateTVC *snowListC =
                       [[sl childViewControllers] firstObject];

                   snowListC.saveList = ^(NSString *item) {

                     SnowList *s = [[SnowList alloc] init];
                     s.title = item;

                     [[SnowDataManager sharedInstance]
                                      saveList:s
                         WithCompletionHandler:^(NSError *error, NSArray *list){

                         }];

                     [self reload];

                   };

                 }];
}

@end
