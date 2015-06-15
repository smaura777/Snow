//
//  SnowThemeSwitcher.m
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowThemeSwitcher.h"

@interface SnowThemeSwitcher ()

@end

@implementation SnowThemeSwitcher

- (void)viewDidLoad {
  [super viewDidLoad];
  _themeNames = @[ @"Grass", @"Azure", @"Sunny", @"Neon", @"Light" ];
  _selectedTheme = [[SnowAppearanceManager sharedInstance] currentTheme];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.

  //    CGRect labelFrame = CGRectMake(0, 0, self.view.bounds.size.width,
  //    self.view.bounds.size.height);
  //    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:labelFrame];
  //
  //    emptyLabel.text = @"No Theme Data found";
  //    emptyLabel.numberOfLines = 0;
  //    emptyLabel.textAlignment = NSTextAlignmentCenter;
  //    emptyLabel.textColor = [UIColor blackColor];
  //    emptyLabel.font = [UIFont fontWithName:@"Palatino-italic" size:20];
  //    [emptyLabel sizeToFit];
  //
  //    self.tableView.backgroundView = emptyLabel;
  //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [_themeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"theme"
                                      forIndexPath:indexPath];

    cell.backgroundColor = [UIColor clearColor];
    cell.tintColor =
    [[SnowAppearanceManager sharedInstance] currentTheme].primary;
    cell.textLabel.textColor =
    [[SnowAppearanceManager sharedInstance] currentTheme].textColor;
    
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    
  cell.textLabel.text = [_themeNames objectAtIndex:indexPath.row];

  if ([_selectedTheme.themeKey
          isEqualToString:[cell.textLabel.text lowercaseString]]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.font =  [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font =  [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  }

  return cell;
}

#pragma mark - Table view delegates

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

  UITableViewCell *cell =
      [self tableView:tableView cellForRowAtIndexPath:indexPath];

  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    return;
  } else {
    _selectedTheme = [[SnowTheme alloc] initWithThemeName:cell.textLabel.text];

    [[SnowAppearanceManager sharedInstance] setCurrentTheme:_selectedTheme];

    [[SnowAppearanceManager sharedInstance] saveDefaultTheme:_selectedTheme];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"SnowThemeUpdate"
                      object:self];

    [self.tableView reloadData];
  }
}

@end
