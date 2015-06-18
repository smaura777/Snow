//
//  SnowSearchTVC.m
//  snow
//
//  Created by samuel maura on 5/20/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowSearchTVC.h"
#import "AppDelegate.h"

@interface SnowSearchTVC ()

@end

@implementation SnowSearchTVC {
  SnowListManager *_listManager;
  UISearchController *_searchController;
  SnowSearchResultsTVC *_searchResultTVC;
  UISearchBar *_searchBar;

  NSArray *taskList;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,
  // self.view.frame.size.width, 44.0)];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  UIBarButtonItem *drawer = [[UIBarButtonItem alloc]
      initWithImage:[UIImage imageNamed:@"snow_menu_drawer"]
              style:UIBarButtonItemStylePlain
             target:self
             action:@selector(toggleMenu:)];

  self.navigationItem.leftBarButtonItem = drawer;

  _listManager = [SnowListManager new];
  [_listManager refresh];
  [_listManager refreshArchived];

  _searchResultTVC =
      [[SnowSearchResultsTVC alloc] initWithStyle:UITableViewStylePlain];

  _searchResultTVC.delegate = self;

  _searchController = [[UISearchController alloc]
      initWithSearchResultsController:_searchResultTVC];

  _searchController.searchResultsUpdater = self;
  _searchController.delegate = self;

  [_searchController.searchBar sizeToFit];
  [_searchController.searchBar setSearchBarStyle:UISearchBarStyleMinimal];

  _searchController.searchBar.delegate = self;
  self.navigationItem.titleView = _searchController.searchBar;

  // self.tableView.tableHeaderView = _searchController.searchBar;

  // self.tableView.tableHeaderView.backgroundColor = [UIColor redColor];

  _searchController.hidesNavigationBarDuringPresentation = NO;
  //_searchController.hidesBottomBarWhenPushed = NO;

  //  self.navigationController

  self.definesPresentationContext = YES;

  //_searchController.searchBar.backgroundColor = [UIColor redColor];

  // AppDelegate *app = (AppDelegate *) [ [UIApplication sharedApplication]
  // delegate] ;

  //  [[UIApplication sharedApplication] setStatusBarStyle:
  //  UIStatusBarStyleLightContent];

  /*
  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
  setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor
  redColor]}];
   */
}

/*
- (void)applyTheme {
  [super applyTheme];


  [_searchController.searchBar
      setTintColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                       .primary];

  [[UITextField appearanceWhenContainedIn:[_searchController.searchBar class],
                                          nil] setDefaultTextAttributes:@{
    NSForegroundColorAttributeName :
        [UIColor redColor]
  }];

}
*/

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];

  // self.navigationController.navigationBar.barTintColor = [UIColor
  // whiteColor];

  /*
[[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
    setDefaultTextAttributes:@{
      NSForegroundColorAttributeName : [UIColor redColor]
    }];

_searchBar.tintColor = [UIColor whiteColor];
  */

  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
      setDefaultTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:14],
        NSForegroundColorAttributeName : [UIColor whiteColor]
      }];
}

- (void)viewDidAppear:(BOOL)animated {
  if (taskList && ([taskList count] > 0)) {

    [_searchController setActive:YES];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView
dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#>
forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}
*/

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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)toggleMenu:(id)sender {
  self.menuTapped();
}

#pragma mark - search delegates  UISearchControllerDelegate

- (void)willPresentSearchController:(UISearchController *)searchController {
  // NSLog(@" %s", __func__);
}

- (void)presentSearchController:(UISearchController *)searchController {
  // NSLog(@" %s", __func__);
  // NSLog(@"SEARCH_CONTROLLER FRAME %@", searchController);
}

- (void)didPresentSearchController:(UISearchController *)searchController {
  // NSLog(@" %s", __func__);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
  // NSLog(@" %s", __func__);
}

#pragma mark - UISearchResultsUpdating delegate method
- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {

  NSString *searchedItem = searchController.searchBar.text;
  // NSLog(@"Searching for %@ ...", searchedItem);
  NSString *trimmedSearchString = [searchController.searchBar.text
      stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"title contains[cd] %@", trimmedSearchString];

  taskList = [[_listManager fetchTasks] filteredArrayUsingPredicate:predicate];

  SnowSearchResultsTVC *resultTVC =
      (SnowSearchResultsTVC *)searchController.searchResultsController;
  resultTVC.taskList = taskList;
  [resultTVC.tableView reloadData];
}

- (void)popDetail {
  [self.navigationController popViewControllerAnimated:YES];
  //[self reload];
}

- (void)loadTask:(SnowTask *)task {
  SnowList *selectedList = [_listManager getListWithID:task.listID];

  SnowTaskDetailsTVC *details =
      [[SnowTaskDetailsTVC alloc] initWithStyle:UITableViewStyleGrouped];

  details.delegate = self;
  details.detailTask = task;
  details.parentList = selectedList;

  [self.navigationController pushViewController:details animated:YES];
  [_searchController dismissViewControllerAnimated:NO completion:nil];
}

@end
