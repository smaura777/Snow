//
//  SnowDebugAvailableFonts.m
//  snow
//
//  Created by samuel maura on 5/24/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowDebugAvailableFonts.h"
#import "SnowCardA.h"
#import "SnowAppearanceManager.h"

@interface SnowDebugAvailableFonts ()

@end

@implementation SnowDebugAvailableFonts {
  NSMutableDictionary *fonts;
}

- (void)SnowDebug_printFonts {
  // NSLog(@"============= FONT FAMILIES =============");
  fonts = [NSMutableDictionary new];

  for (NSString *ff in [UIFont familyNames]) {
    NSMutableArray *fontFamily = [NSMutableArray new];
    for (NSString *fn in [UIFont fontNamesForFamilyName:ff]) {
      [fontFamily addObject:fn];
    }

    [fonts setObject:fontFamily forKey:ff];
  }
}

- (void)close:(id)sender {
  [self.presentingViewController dismissViewControllerAnimated:YES
                                                    completion:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UINib *cellNIB = [UINib nibWithNibName:@"SnowCardA" bundle:nil];

  [self.tableView registerNib:cellNIB forCellReuseIdentifier:@"snow_card_a"];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 100.0;

  [self SnowDebug_printFonts];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(close:)];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return [[fonts allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  NSString *fontkey = [[fonts allKeys] objectAtIndex:section];
  return [[fonts objectForKey:fontkey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  SnowCardA *cell = [tableView dequeueReusableCellWithIdentifier:@"snow_card_a"
                                                    forIndexPath:indexPath];

  [self configCell:cell WithIdentifier:1 atIndexPath:indexPath];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {

  return [[fonts allKeys] objectAtIndex:section];
}

- (void)configCell:(UITableViewCell *)cellIn
    WithIdentifier:(NSUInteger)identifier
       atIndexPath:(NSIndexPath *)indexPath {

  SnowCardA *cell = (SnowCardA *)cellIn;
  NSString *fontkey = [[fonts allKeys] objectAtIndex:indexPath.section];
  NSString *fontName =
      [[fonts objectForKey:fontkey] objectAtIndex:indexPath.row];

  cell.dataContainerView.backgroundColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  cell.listName.text = fontName;
  cell.taskTitle.text = @"NKVD Projet 951";
  UIFont *cfont = [UIFont fontWithName:fontName size:36];

  cell.taskTitle.font = cfont;
}

@end
