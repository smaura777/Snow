//
//  SnowMenuTableViewController.m
//  snow
//
//  Created by samuel maura on 3/31/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowMenuTableViewController.h"
#import "SnowThemeSwitcher.h"
#import "SnowBackgroundImageSwitcher.h"
#import "SnowSearchResultsTVC.h"

@interface SnowMenuTableViewController ()

@end

@implementation SnowMenuTableViewController {
  // UISearchController *_searchController;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
    NSProcessInfo *info = [NSProcessInfo processInfo];
    
    NSLog(@"OS Info Major %ld Minor %ld  Patch %ld",
          info.operatingSystemVersion.majorVersion,
          info.operatingSystemVersion.minorVersion,
          info.operatingSystemVersion.patchVersion
          );
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}




- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [super tableView:tableView cellForRowAtIndexPath:indexPath];

  NSLog(@"Cell view tag %ld ", cell.tag);

  switch (cell.tag) {

  case 5: {

    // Push
    SnowThemeSwitcher *themeSwitcher = (SnowThemeSwitcher *)
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
            instantiateViewControllerWithIdentifier:@"themeTable"];

    [self.navigationController pushViewController:themeSwitcher animated:YES];

  } break;
  case 8: {

    SnowBackgroundImageSwitcher *backgroundSwitcher =
        (SnowBackgroundImageSwitcher *)
            [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                instantiateViewControllerWithIdentifier:@"background_switcher"];

    [self.navigationController pushViewController:backgroundSwitcher
                                         animated:YES];

  } break;
  case 20: {
    NSLog(@"Search invoke");
    /**
    [self presentViewController:_searchController animated:YES completion:^{
        NSLog(@"NOTHING");
    }];
     **/
    self.appMenuSelected(cell.tag);

  } break;
  default:
    self.appMenuSelected(cell.tag);
    break;
  }
}





@end
