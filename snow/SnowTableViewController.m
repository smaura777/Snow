//
//  SnowTableViewController.m
//  snow
//
//  Created by samuel maura on 3/18/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTableViewController.h"
#import "SnowListCreateTVC.h"
#import "SnowTaskCreateTVC.h"
#import "SnowCellA.h"
#import "SnowAppearanceManager.h"

#import "SnowListManager.h"
#import "SnowDebugAvailableFonts.h"

#define kSnowGreen [UIColor colorWithRed:0.0 green:1.0 blue:0.9 alpha:1.0]
#define kSnowGreenPure [UIColor colorWithRed:0.4 green:1.0 blue:1.0 alpha:1.0]
//#define kSnowGreen2 [UIColor colorWithRed:0.6 green:1.0 blue:0.9 alpha:0.90]

#define kSnowGreen2                                                            \
  [UIColor colorWithHue:0.48 saturation:0.3 brightness:0.9 alpha:1.0]

#define kSnowBlue [UIColor colorWithRed:0.0 green:0.7 blue:1.0 alpha:1.0]
#define kSnowBlack [UIColor colorWithRed:0.10 green:0.15 blue:0.10 alpha:1.0]
#define kSnowSilver [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0]

@interface SnowTableViewController () {
  NSArray *test;
}

@end

@implementation SnowTableViewController {
  BOOL _firstLoad;
  NSUInteger _currentSectionCount;
  SnowListManager *_listManager;
  UIView *_segmentWrapper;
  UISegmentedControl *_filter;
  NSArray *_listTableSorted;
  NSString *_emptyMessage;
  UILabel *_emptyLabel;
}

- (void)showQuickTimer:(id)sender {
  /**
  SnowQuickTimerMasterTVC *masterTimer = [[SnowQuickTimerMasterTVC alloc]
                                          initWithStyle:UITableViewStyleGrouped];

  masterTimer.delegate = self;


  UINavigationController *quickTimerNav = [[UINavigationController alloc]
                                     initWithRootViewController:masterTimer];

  **/

  SnowQuickTimerVC *masterTimer = [[SnowQuickTimerVC alloc] init];

  UINavigationController *quickTimerNav =
      [[UINavigationController alloc] initWithRootViewController:masterTimer];

  // quickTimerNav.modalPresentationStyle = UIModalPresentationCustom;
  // quickTimerNav.transitioningDelegate = self;

  quickTimerNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentViewController:quickTimerNav animated:YES completion:nil];
}

- (void)showAvailableFonts:(id)sender {
  SnowDebugAvailableFonts *afonts = [[SnowDebugAvailableFonts alloc] init];

  UINavigationController *fontNav =
      [[UINavigationController alloc] initWithRootViewController:afonts];

  [self presentViewController:fontNav animated:YES completion:nil];
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
                               // NSLog(@"Completed");
                               [self completeTask:task AtIndexPath:index];

                             }];

  UIAlertAction *ac2 =
      [UIAlertAction actionWithTitle:@"delete"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *action) {
                               // NSLog(@"Cleared");
                               [self deleteTask:task AtIndexPath:index];

                             }];

  UIAlertAction *ac3 =
      [UIAlertAction actionWithTitle:@"cancel"
                               style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction *action){
                                 // NSLog(@"Cancelled");

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

- (void)doIt:(id)sender {

  SnowListCreateTVC *listCreationVC =
      [[SnowListCreateTVC alloc] initWithStyle:UITableViewStyleGrouped];
  UINavigationController *sl = [[UINavigationController alloc]
      initWithRootViewController:listCreationVC];

  sl.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

  // sl.modalPresentationStyle = UIModalPresentationCustom;
  // sl.transitioningDelegate = self;

  // NSLog(@"LC %@", [[sl childViewControllers] firstObject]);

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

- (void)doThat:(id)sender {
  // UIStoryboard *storyBoard =
  //  [UIStoryboard storyboardWithName:@"Main" bundle:nil]; // self.storyboard;

  SnowTaskCreateTVC *createTaskVC =
      [[SnowTaskCreateTVC alloc] initWithStyle:UITableViewStyleGrouped];

  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:createTaskVC];

  [_listTable objectForKey:[[_listTable allKeys] firstObject]];

  SnowList *defaultOrMostRecentList = [_listManager defaultList];
  if (!defaultOrMostRecentList) {

    [self showAlertWithTitle:@"Notice"
                  AndMessage:@"Please create a list for your task"];

    return;
  }

  createTaskVC.selectedList = defaultOrMostRecentList;

  //[_listTable objectForKey:[[_listTable allKeys] firstObject]];

  [createTaskVC populateVC];

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

                       [self reload];

                       [self.tableView reloadData];

                     };

                     // [createTaskVC populateVC];

                   }];
}

- (void)doThis:(id)sender {
  return;

  /**

  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Task"
                       message:@""
                preferredStyle:UIAlertControllerStyleActionSheet];


  CGRect toolFrame = CGRectMake(0, 10, 270, 375);
  UIView *toolView = [[UIView alloc] initWithFrame:toolFrame];

  toolView.backgroundColor = [UIColor redColor];

  UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
  [b1 setTitle:@"GO" forState:UIControlStateNormal];

  [b1 setTintColor:[UIColor blueColor]];

  b1.layer.borderWidth = 1.0;
  b1.layer.borderColor = [UIColor blueColor].CGColor;

  [toolView addSubview:b1];

  [alert.view addSubview:toolView];

  [alert.view
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:alert.view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:toolView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:20.0]];



  //NSLog(@"Alert view bounds : width %lg  height %lg  x: %lg  y : %lg ",
        alert.view.bounds.size.width, alert.view.bounds.size.height,
        alert.view.bounds.origin.x, alert.view.bounds.origin.y);

  [self presentViewController:alert animated:YES completion:nil];

  //NSLog(@"Alert view frame : width %lg  height %lg  x: %lg  y : %lg ",
        alert.view.frame.size.width, alert.view.frame.size.height,
        alert.view.frame.origin.x, alert.view.frame.origin.y);

  //NSLog(@"ALERT VIEW SUBVIEWS : %@ ", [alert.view subviews]);
   **/
}

- (void)viewTap:(id)sender {
  // NSLog(@"VIEW TAPPED ");
}

/*
- (void)Yeah:(id)sender {
  return;

  //CGRect toolFrame = CGRectMake(100, 100, 200, 200);

  // CGRect fullFrame = CGRectMake(0, 0, , <#CGFloat height#>);

  CGRect fullFrame = [[UIScreen mainScreen] bounds];

  UIView *toolView = [[UIView alloc] initWithFrame:fullFrame];

  [toolView setAlpha:0];

  toolView.backgroundColor = [UIColor redColor];

  [toolView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                             action:@selector(viewTap:)]];

  [self.navigationController.view addSubview:toolView];
  [UIView animateWithDuration:0.2
                   animations:^{
                     [toolView setAlpha:0.5];
                   }];
}
*/

/*
-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;

}
*/

- (void)viewDidLoad {

  [super viewDidLoad];

  [self updateAnalyticsWithScreen:@"Home Screen"];
  _emptyMessage = @"No tasks";

  // [self setNeedsStatusBarAppearanceUpdate];

  // [self applyTheme];

  _firstLoad = YES;

  // Register cell

  [self.tableView registerClass:[SnowCellA class]
         forCellReuseIdentifier:@"cellA"];

  [self.tableView registerClass:[SnowCardA2 class]
         forCellReuseIdentifier:@"snow_card_a2"];

  UINib *cellNIB = [UINib nibWithNibName:@"SnowCardA" bundle:nil];
  [self.tableView registerNib:cellNIB forCellReuseIdentifier:@"snow_card_a"];

  self.tableView.rowHeight = UITableViewAutomaticDimension;

  self.tableView.estimatedRowHeight = 44.0;

  //_localTblList = [NSArray new];
  //_localTblTask = [NSArray new];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  /*
   [UIView setAnimationsEnabled:NO];
   self.navigationItem.prompt = @"\t";
   [UIView setAnimationsEnabled:YES];
  */

  UIBarButtonItem *item = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_bar_list"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(doIt:)];

  UIBarButtonItem *item2 = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_bar_add"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(doThat:)];

  /*
 UIBarButtonItem *item3 =
     [[UIBarButtonItem alloc] initWithTitle:@"A+"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showAvailableFonts:)];
*/

  UIBarButtonItem *item4 = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_bar_timer"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(showQuickTimer:)];

  self.navigationItem.rightBarButtonItems = @[ item, item2, item4 ];

  UIBarButtonItem *drawer = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_menu_drawer"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(toggleMenu:)];

  self.navigationItem.leftBarButtonItem = drawer;

  _listManager = [SnowListManager new];

  CGRect wrapperFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 100);
  // CGRect segmentFrame = CGRectInset(wrapperFrame, 40, 25);

  _segmentWrapper = [[UIView alloc] initWithFrame:wrapperFrame];

  _filter = [[UISegmentedControl alloc]
      initWithItems:@[ @"all", @"low", @"medium", @"high" ]];

  /*
_filter.frame = segmentFrame;
_filter.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                           UIViewAutoresizingFlexibleRightMargin;

   */

  [_segmentWrapper addSubview:_filter];

  /*
_segmentWrapper.backgroundColor =
    [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  */

  _filter.tintColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  self.tableView.tableHeaderView = _segmentWrapper;

  [_filter addTarget:self
                action:@selector(filterTasks:)
      forControlEvents:UIControlEventValueChanged];

  _filter.selectedSegmentIndex = 0;

  [self positionSegmentView];
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

- (void)filterTasks:(id)sender {
  UISegmentedControl *taskSelector = (UISegmentedControl *)sender;

  NSInteger _taskStatus = taskSelector.selectedSegmentIndex;

  // NSLog(@"Selected %@", [taskSelector titleForSegmentAtIndex:_taskStatus]);

  switch (_taskStatus) {
  case 0: {
    _emptyMessage = @"No tasks";
    [self reload];
  } break;
  case 1: {
    _emptyMessage = @"No low priority tasks";
    [self reloadFilterLow];
  } break;
  case 2: {
    _emptyMessage = @"No medium priority tasks";
    [self reloadFilterMedium];
  } break;
  case 3: {
    _emptyMessage = @"No high priority tasks";
    [self reloadFilterHigh];
  } break;

  default:
    [self reload];
    break;
  }
}

- (void)applyTheme {
  [super applyTheme];

  _segmentWrapper.backgroundColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
}

// OVERRIDE BASE
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[SnowLoggingManager sharedInstance]
      SnowLog:@"View will appear called inside %s", __func__];

  // [self applyTheme];

  // Setup background change notifications

  //  [[NSNotificationCenter defaultCenter] addObserver:self
  //                                           selector:@selector(updateBackground:)
  //                                               name:@"SnowBackgroundUpdate"
  //                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(remoteTaskUpdate)
                                               name:SNOW_COMPLETE_NOTIF
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(remoteTaskUpdate)
                                               name:SNOW_CLEAR_NOTIF
                                             object:nil];

  switch (_filter.selectedSegmentIndex) {
  case 0:
    [self reload];
    break;

  case 1:
    [self reloadFilterLow];
    break;

  case 2:
    [self reloadFilterMedium];
    break;

  case 3:
    [self reloadFilterHigh];
    break;

  default:
    [self reload];
    break;
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)reload {
  [_listManager refresh];

  /*
  _listTable = [_listManager fetch];
  _currentSectionCount = _listManager.listWithPendingTasksCount;
   */

  _listTableSorted = [_listManager fetchSorted];
  _currentSectionCount = [_listTableSorted count];

  if (!_firstLoad) {
    [self.tableView reloadData];
  }

  _firstLoad = NO;
}

- (void)reloadFilterLow {
  [_listManager refreshLow];

  //  _listTable = [_listManager fetch];
  //  _currentSectionCount = _listManager.listWithPendingTasksCount;

  _listTableSorted = [_listManager fetchSorted];
  _currentSectionCount = [_listTableSorted count];

  [self.tableView reloadData];
}

- (void)reloadFilterMedium {
  [_listManager refreshMedium];

  //  _listTable = [_listManager fetch];
  //  _currentSectionCount = [[_listTable allKeys] count];

  _listTableSorted = [_listManager fetchSorted];
  _currentSectionCount = [_listTableSorted count];

  [self.tableView reloadData];
}

- (void)reloadFilterHigh {
  [_listManager refreshHigh];

  //  _listTable = [_listManager fetch];
  //  _currentSectionCount = [[_listTable allKeys] count];

  _listTableSorted = [_listManager fetchSorted];
  _currentSectionCount = [_listTableSorted count];

  [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  // NSInteger section_count = [[_listTable allKeys] count];

  NSInteger section_count = [_listTableSorted count];

  if (_emptyLabel == nil) {
    _emptyLabel = [[UILabel alloc] init];
  }

  [self showEmptyDataMessageIfNeeded:section_count
                             WithMsg:_emptyMessage
                            AndLabel:_emptyLabel];

  return section_count;
}

/*
- (void)showEmptyDataMessageIfNeeded:(NSInteger)sec_count {

  if (sec_count == 0) {
    //NSLog(@"You have not created any tasks yet %@ ",
          self.tableView.backgroundView);
    if (self.tableView.backgroundView == nil) {
      _emptyLabel = [[UILabel alloc] init];
      _emptyLabel.frame = self.tableView.frame;
      _emptyLabel.textAlignment = NSTextAlignmentCenter;
      _emptyLabel.font =
          [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
      _emptyLabel.textColor =
          [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.7];
      _emptyLabel.text = _emptyMessage;
      self.tableView.backgroundView = _emptyLabel;
    } else {
      // Update label text only
      _emptyLabel.text = _emptyMessage;
    }

  } else {
    self.tableView.backgroundView = nil;
  }
}
*/

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  /*
NSString *section_name = [[_listTable allKeys] objectAtIndex:section];
SnowList *list = [_listTable objectForKey:section_name];

return [list.tasklist count];
*/

  return [[[_listTableSorted objectAtIndex:section] tasklist] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  /*
  SnowCardA *cell = [tableView dequeueReusableCellWithIdentifier:@"snow_card_a"
                                                  forIndexPath:indexPath];

  */
  SnowCardA2 *cell =
      [tableView dequeueReusableCellWithIdentifier:@"snow_card_a2"
                                      forIndexPath:indexPath];

  [self configCell:cell WithIdentifier:1 atIndexPath:indexPath];

#ifdef DEBUG
// //NSLog(@"Cell recursive description:\n\n%@\n\n", [cell
// performSelector:@selector(recursiveDescription)]);
#endif

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 88.0;
}

/*
- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
  NSArray *keys = [_listTable allKeys];

  NSString *section_name = [keys objectAtIndex:section];

  return section_name;
}
*/

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {

  /*
  NSString *tg = [[_listTable allKeys] objectAtIndex:section];
  SnowList *list = [_listTable objectForKey:tg];
   */

  SnowList *list = [_listTableSorted objectAtIndex:section];

  CGRect viewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 80);

  CGRect labelFrame = CGRectInset(viewFrame, 10, 10);

  UILabel *header = [[UILabel alloc] initWithFrame:labelFrame];

  header.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:.7];

  header.font = [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:28];

  static NSDateFormatter *format = nil;

  if (format == nil) {
    format = [[NSDateFormatter alloc] init];
    format.dateStyle = NSDateFormatterShortStyle;
    format.timeStyle = NSDateFormatterShortStyle;
  }

  //  header.text =
  //      [NSString stringWithFormat:@" %@  - %@", [list.title
  //      capitalizedString],
  //                                 [format stringFromDate:list.lastupdated]];

  header.text =
      [NSString stringWithFormat:@" %@", [list.title capitalizedString]];

  UIView *head = [[UIView alloc] initWithFrame:viewFrame];

  [head addSubview:header];

  return head;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  /*
  NSString *tg = [[_listTable allKeys] objectAtIndex:indexPath.section];
  SnowList *selectedList = [_listTable objectForKey:tg];
*/
  SnowList *selectedList = [_listTableSorted objectAtIndex:indexPath.section];

  SnowTask *selectedTask = [selectedList.tasklist objectAtIndex:indexPath.row];

  /**
UINavigationController* nav = (UINavigationController*)
      [storyBoard instantiateViewControllerWithIdentifier:@"task_create_sb"];
  nav.modalPresentationStyle = UIModalPresentationCustom;
  nav.transitioningDelegate = self;

**/

  SnowTaskDetailsTVC *details =
      [[SnowTaskDetailsTVC alloc] initWithStyle:UITableViewStyleGrouped];

  details.delegate = self;
  details.detailTask = selectedTask;
  details.parentList = selectedList;

  [self.navigationController pushViewController:details animated:YES];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView
    canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return NO;
}

- (void)deleteTask:(SnowTask *)task AtIndexPath:(NSIndexPath *)indexPath {
  task.deleted = YES;

  [[SnowDataManager sharedInstance]
                 updateTask:task
      WithCompletionHandler:^(NSError *error, NSDictionary *tasks){
          // NSLog(@"Delete operation completed for task ");

      }];

  [self updateTableActionsFor:task AtIndex:indexPath];
}

- (void)updateTableActionsFor:(SnowTask *)task
                      AtIndex:(NSIndexPath *)indexPath {

  // ==== Cache data update ===========//

  NSMutableArray *tmpTaskArray = [NSMutableArray new];

  SnowList *tmpList = [_listTableSorted objectAtIndex:indexPath.section];

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
          // NSLog(@"Update operation completed for task ");
      }];

  [self updateTableActionsFor:task AtIndex:indexPath];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  // NSLog(@"Value entered in field is : %@ ", textField.text);
}

- (void)toggleMenu:(id)sender {
  self.menuTapped();
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForPresentedController:(UIViewController *)presented
                     presentingController:(UIViewController *)presenting
                         sourceController:(UIViewController *)source {
  SnowCustomTransition *sct = [[SnowCustomTransition alloc] init];
  sct.appearing = YES;

  return sct;
}

- (id<UIViewControllerAnimatedTransitioning>)
animationControllerForDismissedController:(UIViewController *)dismissed {
  SnowCustomTransition *sct = [[SnowCustomTransition alloc] init];
  sct.appearing = NO;

  return sct;
}

- (void)configCell:(UITableViewCell *)cellIn
    WithIdentifier:(NSUInteger)identifier
       atIndexPath:(NSIndexPath *)indexPath {

  // NSString *tg = [[_listTable allKeys] objectAtIndex:indexPath.section];

  // SnowList *currentList = [_listTable objectForKey:tg];

  SnowList *currentList = [_listTableSorted objectAtIndex:indexPath.section];

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
    cell.dataContainerView.backgroundColor =
        [UIColor colorWithRed:.88 green:.88 blue:.88 alpha:1];

    cell.taskTitle.text = x.title;

    if (x.reminder) {
      cell.dueDate.text =
          [NSString stringWithFormat:@"%@", [format stringFromDate:x.reminder]];
    } else {
      cell.dueDate.text = @""; //[format stringFromDate:x.created];
    }

    cell.listName.text = currentList.title; //@"Shopping";

    cell.deleteTask = ^{
      [self deleteTask:x AtIndexPath:indexPath];
    };

    cell.completeTask = ^{
      [self completeTask:x AtIndexPath:indexPath];
    };

    cell.task = currentTask;
    cell.cellPath = indexPath;
    cell.delegate = self;

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

- (void)updateBackground:(NSNotification *)note {
  UIImage *theImage =
      [[[SnowAppearanceManager sharedInstance] currentBackground] background];

  UIImageView *tableImage = [[UIImageView alloc] initWithImage:theImage];

  tableImage.contentMode = UIViewContentModeScaleAspectFill;
  self.tableView.backgroundView = tableImage;
}

#pragma mark - SnowTaskDetailTVCDelegate

- (void)popDetail {
  [self.navigationController popViewControllerAnimated:YES];
  //[self reload];
}

#pragma mark - SnowQuicktTimerMasterDelegate

- (void)closeTimerView {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - task Options tapped

- (void)taskOptionsTapped:(id)sender {
  // NSLog(@"Task Options tapped ========= ======= +++++++++++++++");
}

#pragma mark - Remote task updates

- (void)remoteTaskUpdate {

  [self reload];
}

@end
