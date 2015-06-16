//
//  SnowMenuTVCA1.m
//  snow
//
//  Created by samuel maura on 5/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowMenuTVCA1.h"
#import "SnowSoundPicker.h"
#import "SnowAboutMaster.h"

@interface SnowMenuTVCA1 ()

@end

@implementation SnowMenuTVCA1 {
  NSArray *_menuEntries;
  NSArray *_menuImageNames;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self applyTheme];

  [self.tableView registerClass:[SnowCellTypeA1 class]
         forCellReuseIdentifier:@"SnowCellTypeA1"];

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"basic"];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  self.tableView.separatorColor = tableBackgroundColor;

  //  self.tableView.backgroundColor = tableBackgroundColor;

  self.tableView.rowHeight = 50;

  /*
  [UIView setAnimationsEnabled:NO];
  self.navigationItem.prompt = @"\t";
  [UIView setAnimationsEnabled:YES];
  */

  // self.tableView.rowHeight = UITableViewAutomaticDimension;
  // self.tableView.estimatedRowHeight = 80.0;

  _menuEntries = @[
    @"home",
    @"search",
    @"list",
    @"archive",
    @"themes",
    @"sound",
    @"background",
    @"settings"
  ];

  _menuImageNames = @[
    @"snow_menu_home",
    @"snow_menu_search",
    @"snow_menu_list",
    @"snow_menu_archive",
    @"snow_menu_settings",
    @"snow_menu_settings",
    @"snow_menu_settings",
    @"snow_menu_settings"
  ];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  /*
CGRect headerFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 80);

UIView *header = [[UIView alloc] initWithFrame:headerFrame];

UILabel *menuHeaderTitle = [[UILabel alloc] initWithFrame:headerFrame];
UIColor *btTextColor =
    [UIColor colorWithHue:0.5 saturation:1 brightness:1 alpha:1];

menuHeaderTitle.text = @"iceberg";
menuHeaderTitle.textColor = btTextColor;
menuHeaderTitle.textAlignment = NSTextAlignmentCenter;
menuHeaderTitle.font =
    [UIFont fontWithName:@"AvenirNext-Regular" size:28];

header.backgroundColor =
    [UIColor colorWithHue:0 saturation:0 brightness:0.04 alpha:1];

[header addSubview:menuHeaderTitle];

self.tableView.tableHeaderView = header;


  */
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // self.tableView.backgroundColor = [UIColor blackColor];
  [self.tableView reloadData];
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
  NSLog(@"mENU ITEM COUNT = %ld", [_menuEntries count]);
  return [_menuEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  /*
    SnowCellTypeA1 *cell =
        [tableView dequeueReusableCellWithIdentifier:@"SnowCellTypeA1"
                                        forIndexPath:indexPath];
    */

  SnowCellTypeA1 *cell =
      [[SnowCellTypeA1 alloc] initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:@"blah"];

  cell.backgroundColor = [UIColor clearColor];

  NSLog(@"Populating cell %ld", indexPath.row);

  /*

  UITableViewCell *cell =
  [tableView dequeueReusableCellWithIdentifier:@"basic"
                                  forIndexPath:indexPath];

  cell.textLabel.text = [_menuEntries objectAtIndex:indexPath.row];

  */

  NSString *menuTitle = [_menuEntries objectAtIndex:indexPath.row];

  cell.buttonLabel = menuTitle;
  cell.buttonImage = [_menuImageNames objectAtIndex:indexPath.row];

  [cell setup];

  // cell.selectionStyle = UITableViewCellSelectionStyleNone;

  // Configure the cell...

  [cell.menuButton addTarget:self
                      action:@selector(btapped:)
            forControlEvents:UIControlEventTouchUpInside];

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

#pragma mark - table delegate

- (void)btapped:(id)sender {
  SnowButtonTypeA2 *bt = (SnowButtonTypeA2 *)sender;
  NSString *listMenu = @"list";
  NSString *homeMenu = @"home";
  NSString *searchMenu = @"search";
  NSString *archiveMenu = @"archive";
  NSString *themeMenu = @"themes";
  NSString *settingsMenu = @"settings";
  NSString *soundMenu = @"sound";

  NSLog(@"button tapped in %s  for cell %@", __func__, bt.titleLabel.text);

  if ([listMenu isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    self.appMenuSelected([bt.titleLabel.text lowercaseString]);
  } else if ([homeMenu isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    self.appMenuSelected([bt.titleLabel.text lowercaseString]);
  } else if ([searchMenu
                 isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    self.appMenuSelected([bt.titleLabel.text lowercaseString]);
  } else if ([archiveMenu
                 isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    self.appMenuSelected([bt.titleLabel.text lowercaseString]);
  } else if ([themeMenu isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    SnowThemeSwitcher *themeSwitcher = (SnowThemeSwitcher *)
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
            instantiateViewControllerWithIdentifier:@"themeTable"];

    [self.navigationController pushViewController:themeSwitcher animated:YES];

  } else if ([settingsMenu
                 isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    self.appMenuSelected([bt.titleLabel.text lowercaseString]);
  } else if ([soundMenu isEqualToString:[bt.titleLabel.text lowercaseString]]) {
    // show vc

    SnowSoundPicker *soundPicker =
        [[SnowSoundPicker alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:soundPicker animated:YES];
  }
}

@end