//
//  SnowAboutMaster.m
//  snow
//
//  Created by samuel maura on 6/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowAboutMaster.h"
#import "SnowTwoLabelCell.h"
#import "SnowWeb.h"

@interface SnowAboutMaster ()

@end

@implementation SnowAboutMaster {
  NSArray *_entries;
}

static NSString *privacy = @"http://glifn.com/privacy/";

static NSString *homePage = @"http://glifn.com/snow/";

- (void)viewDidLoad {
  [super viewDidLoad];
    
     [self updateAnalyticsWithScreen:@"About Screen"]; 

  _entries = @[ @"About", @"Privacy Policy", @"Version" ];

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
  NSInteger sectionCount = [_entries count];

  return sectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  UITableViewCell *cell;

  switch (indexPath.row) {
  case 0:
  case 1: {
    cell = [tableView dequeueReusableCellWithIdentifier:@"basic"
                                           forIndexPath:indexPath];
  } break;
  case 2: {
    cell = [tableView dequeueReusableCellWithIdentifier:@"two_label_cell"
                                           forIndexPath:indexPath];
  }

  break;

  default:
    cell = [tableView dequeueReusableCellWithIdentifier:@"basic"
                                           forIndexPath:indexPath];
    break;
  }

  //  SnowTwoLabelCell *cell =
  //      [tableView dequeueReusableCellWithIdentifier:@"basic"
  //                                      forIndexPath:indexPath];

  cell.backgroundColor = [UIColor clearColor];
  NSString *key = [_entries objectAtIndex:indexPath.row];

  switch (indexPath.row) {
  case 0:
  case 1: {

    cell.textLabel.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

    cell.textLabel.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

    cell.textLabel.text = key;

    if (indexPath.row < 2) {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

  } break;
  case 2: {
    SnowTwoLabelCell *twoLabelCell = (SnowTwoLabelCell *)cell;
    twoLabelCell.title.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].textColor;
    twoLabelCell.value.textColor =
        [[SnowAppearanceManager sharedInstance] currentTheme].textColor;
    twoLabelCell.title.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    twoLabelCell.value.font =
        [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    twoLabelCell.title.text = key;
    twoLabelCell.value.text = @"1.0";

  } break;

  default:
    break;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

  NSString *weblink;

  if (indexPath.row > 1) {
    return;
  }

  if (indexPath.row == 0) {
    weblink = homePage;
  } else {
    weblink = privacy;
  }

  SnowWeb *vc = [[SnowWeb alloc] init];
  vc.url = weblink;

  [self.navigationController pushViewController:vc animated:YES];
}

- (void)toggleMenu:(id)sender {
  self.menuTapped();
}

@end
