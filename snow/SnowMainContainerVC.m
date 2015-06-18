//
//  SnowMainContainerVC.m
//  snow
//
//  Created by samuel maura on 3/31/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowMainContainerVC.h"
#import "SnowSearchTVC.h"

@interface SnowMainContainerVC ()

@end

@implementation SnowMainContainerVC {
  UIView *_overlay;

  SystemSoundID wooshSound;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  // NSLog(@"SDFDS");
  return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // NSString *wooshSoundPath =[[NSBundle mainBundle] pathForResource:@"woosh"
  // ofType:@"caf"] ;
  // NSURL *wooshSoundUrl = [NSURL fileURLWithPath:wooshSoundPath];
  // AudioServicesCreateSystemSoundID( (__bridge CFURLRef)wooshSoundUrl,
  // &wooshSound);

  _listManager = [SnowListManager new];

  [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
      setDefaultTextAttributes:@{
        NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:16],
        NSForegroundColorAttributeName : [UIColor whiteColor]
      }];

  [self loadTopChildViewController];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadTopChildViewController {
  _menuOpen = NO;

  _home = (SnowTableViewController *)
      [[UIStoryboard storyboardWithName:@"Main"
                                 bundle:nil] instantiateInitialViewController];

  __weak typeof(self) weakSelf = self;

  _home.menuTapped = ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;

    [strongSelf toggleMenu:nil];
  };

  UINavigationController *nav =
      [[UINavigationController alloc] initWithRootViewController:_home];

  [self addChildViewController:nav];
  [self.view addSubview:nav.view];
  [nav didMoveToParentViewController:self];

  _topVC = nav;
  _topVCTitle = @"Home";
}

- (void)toggleMenu:(id)sender {
  // NSLog(@"Menu tapped......");
  if (_menuOpen == NO) {
    if (!_mainMenuNav) {

      _mainMenu = [[SnowMenuTVCA1 alloc] initWithStyle:UITableViewStylePlain];

      __weak typeof(self) weakSelf = self;

      _mainMenu.appMenuSelected = ^(NSString *menuTilte) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        SnowTableViewController *snowHome;
        SnowListAllTVC *listAll;
        SnowTaskAllTVC *allTasks;

        if ([menuTilte isEqualToString:@"home"]) {
          // NSLog(@"Load Home vc");

          if ([strongSelf.topVCTitle isEqualToString:@"Home"]) {
            [strongSelf toggleMenu:nil];
            return;
          }

          snowHome = (SnowTableViewController *)[[UIStoryboard
              storyboardWithName:@"Main"
                          bundle:nil] instantiateInitialViewController];

          snowHome.menuTapped = ^{
            [strongSelf toggleMenu:nil];
          };

          [strongSelf swappedTopVCWith:[[UINavigationController alloc]
                                           initWithRootViewController:snowHome]
                             WithTitle:@"Home"];

        } else if ([menuTilte isEqualToString:@"list"]) { // List
          // NSLog(@"Load list  vc");
          if ([strongSelf.topVCTitle isEqualToString:@"List"]) {
            [strongSelf toggleMenu:nil];
            return;
          }

          listAll = (SnowListAllTVC *)
              [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                  instantiateViewControllerWithIdentifier:@"SnowListAllTVC"];

          listAll.menuTapped = ^{
            [strongSelf toggleMenu:nil];
          };

          [strongSelf swappedTopVCWith:[[UINavigationController alloc]
                                           initWithRootViewController:listAll]
                             WithTitle:@"List"];

        }

        else if ([menuTilte isEqualToString:@"archive"]) { // task
          // NSLog(@"Load task  vc");
          // Already on top ?
          if ([strongSelf.topVCTitle isEqualToString:@"All_tasks"]) {
            [strongSelf toggleMenu:nil];
            return;
          }

          allTasks = (SnowTaskAllTVC *)
              [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                  instantiateViewControllerWithIdentifier:@"SnowTaskAllTVC"];

          allTasks.menuTapped = ^{
            [strongSelf toggleMenu:nil];
          };

          [strongSelf swappedTopVCWith:[[UINavigationController alloc]
                                           initWithRootViewController:allTasks]
                             WithTitle:@"All_tasks"];
        } else if ([menuTilte isEqualToString:@"search"]) {

          if ([strongSelf.topVCTitle isEqualToString:@"search_vc"]) {
            [strongSelf toggleMenu:nil];
            return;
          }

          SnowSearchTVC *searchVC =
              [[SnowSearchTVC alloc] initWithStyle:UITableViewStylePlain];

          searchVC.menuTapped = ^{
            [strongSelf toggleMenu:nil];
          };

          [strongSelf swappedTopVCWith:[[UINavigationController alloc]
                                           initWithRootViewController:searchVC]
                             WithTitle:@"search_vc"];
        } else if ([menuTilte isEqualToString:@"about"]) {
          if ([strongSelf.topVCTitle isEqualToString:@"about_vc"]) {
            [strongSelf toggleMenu:nil];
            return;
          }

          SnowAboutMaster *about =
              [[SnowAboutMaster alloc] initWithStyle:UITableViewStylePlain];
          about.menuTapped = ^{
            [strongSelf toggleMenu:nil];
          };

          [strongSelf swappedTopVCWith:[[UINavigationController alloc]
                                           initWithRootViewController:about]
                             WithTitle:@"about_vc"];
        }

      };
    }

    _mainMenuNav =
        [[UINavigationController alloc] initWithRootViewController:_mainMenu];
    [self addChildViewController:_mainMenuNav];
    [self.view insertSubview:_mainMenuNav.view belowSubview:_topVC.view];
    [_mainMenuNav didMoveToParentViewController:self];

    CGRect openFrame =
        CGRectMake(self.view.frame.size.width - 40, self.view.frame.origin.y,
                   self.view.frame.size.width, self.view.frame.size.height);

    // Border & Shadow

    // _topVC.view.layer.cornerRadius = 15.0;
    // _topVC.view.layer.borderWidth = 1.0;
    // _topVC.view.layer.borderColor = [UIColor blackColor].CGColor;

    // _topVC.view.clipsToBounds = YES;
    //_topVC.view.layer.masksToBounds = YES;

    _topVC.view.layer.shadowOpacity = 0.5;
    _topVC.view.layer.shadowOffset = CGSizeMake(-8.0, 2.0);

    // Sound effect - open menu
    // animate top view out of the way
    [UIView animateWithDuration:0.25
        animations:^{
          //  AudioServicesPlaySystemSound(wooshSound);
          _topVC.view.frame = openFrame;

        }
        completion:^(BOOL finished) {
          // Add special overlay here
          _overlay = [[UIView alloc] initWithFrame:_topVC.view.frame];
          _overlay.backgroundColor = [UIColor clearColor];
          [self.view addSubview:_overlay];
          UITapGestureRecognizer *tapTopVc = [[UITapGestureRecognizer alloc]
              initWithTarget:self
                      action:@selector(topVCtapped:)];
          tapTopVc.numberOfTapsRequired = 1;
          [_overlay addGestureRecognizer:tapTopVc];

          _menuOpen = YES;

        }];

  } else {
    // animate top view out of the way

    if (_overlay) {
      [_overlay removeFromSuperview];
      _overlay = nil;
    }

    // Sound effect close menu

    [UIView animateWithDuration:0.25
        animations:^{
          //  AudioServicesPlaySystemSound(wooshSound);
          _topVC.view.frame = self.view.frame;

        }
        completion:^(BOOL finished) {

          _topVC.view.layer.shadowOpacity = 0.0;
          _topVC.view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
          //_topVC.view.layer.cornerRadius = 0;

          [_mainMenuNav willMoveToParentViewController:nil];
          [_mainMenuNav.view removeFromSuperview];
          [_mainMenuNav removeFromParentViewController];
          _menuOpen = NO;
        }];
  }
}

- (void)swappedTopVCWith:(UIViewController *)incoming
               WithTitle:(NSString *)vcTitle {
  if ([_topVC isEqual:incoming]) {
    return;
  }

  [_topVC willMoveToParentViewController:nil];

  // Copy old frame
  incoming.view.frame = _topVC.view.frame;

  // Clean up old VC
  [_topVC.view removeFromSuperview];
  [_topVC removeFromParentViewController];

  // Add new VC
  [self addChildViewController:incoming];
  [self.view addSubview:incoming.view];
  [incoming didMoveToParentViewController:self];

  _topVC = incoming;
  _topVCTitle = vcTitle;

  [self toggleMenu:nil];
}

#pragma mark - UISearchResultsUpdating delegate method
- (void)updateSearchResultsForSearchController:
    (UISearchController *)searchController {

  //NSString *searchedItem = searchController.searchBar.text;
  // NSLog(@"Searching for %@ ...", searchedItem);
  NSArray *taskList = [_listManager fetchTasks];
  SnowSearchResultsTVC *resultTVC =
      (SnowSearchResultsTVC *)searchController.searchResultsController;
  resultTVC.taskList = taskList;
  [resultTVC.tableView reloadData];
}

#pragma mark - topGesture
- (void)topVCtapped:(UITapGestureRecognizer *)tap {
  // NSLog(@" ... Overlay view tapped....");
  [self toggleMenu:nil];
}

@end
