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

static NSString *privacy = @"http://glifn.com";

static NSString *homePage = @"http://glifn.com";

- (void)viewDidLoad {
  [super viewDidLoad];

  _entries = @[ @"About", @"Privacy Policy", @"Version\t\t\t\t1.0" ];

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
  SnowTwoLabelCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"basic"
                                      forIndexPath:indexPath];

  // Configure the cell...
  cell.backgroundColor = [UIColor clearColor];
  NSString *key = [_entries objectAtIndex:indexPath.row];

  cell.textLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;

  cell.textLabel.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

  cell.textLabel.text = key;

  // cell.value.textColor =  [[SnowAppearanceManager sharedInstance]
  // currentTheme].textColor;
  // cell.value.font = [UIFont
  // preferredFontForTextStyle:UIFontTextStyleHeadline];

  // cell.value.text = [_entries objectForKey:key];

  if (indexPath.row < 2) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  if (indexPath.section > 1) {
    return;
  }

  SnowWeb *vc = [[SnowWeb alloc] init];
//  UINavigationController *nav =
//      [[UINavigationController alloc] initWithRootViewController:vc];
  vc.url = privacy;
    [self.navigationController pushViewController:vc animated:YES ];
  
}

- (void)toggleMenu:(id)sender {
  self.menuTapped();
}

@end
