//
//  SnowBackgroundImageSwitcher.m
//  snow
//
//  Created by samuel maura on 4/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowBackgroundImageSwitcher.h"

@interface SnowBackgroundImageSwitcher ()

@end

@implementation SnowBackgroundImageSwitcher

- (void)viewDidLoad {
  [super viewDidLoad];
  _imageThemes = @[
    @"desert",
    @"eiffel & bridge",
    @"eiffel at dawn",
    @"london skyline dawn",
    @"london skyline daylight",
    @"london skyline sunset",
    @"monkey fucata",
    @"New York night sky",
    @"snow monkeys",
    @"taj mahal",
    @"eiffel romantic"
  ];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  _selectedBackground =
      [[SnowAppearanceManager sharedInstance] currentBackground];
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
  return [_imageThemes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"background_image"
                                      forIndexPath:indexPath];

  cell.textLabel.text = [_imageThemes objectAtIndex:indexPath.row];

  if ([_selectedBackground.backgroundKey isEqualToString:cell.textLabel.text]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.font = [UIFont systemFontOfSize:21.0 weight:9.0];
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0 weight:0.0];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];

  UITableViewCell *cell =
      [self tableView:tableView cellForRowAtIndexPath:indexPath];

  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    return;
  } else {
    _selectedBackground =
        [[SnowBackground alloc] initWithBackgroundName:cell.textLabel.text];

    [[SnowAppearanceManager sharedInstance]
        setCurrentBackground:_selectedBackground];

    [[SnowAppearanceManager sharedInstance]
        saveDefaultBackground:_selectedBackground];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"SnowBackgroundUpdate"
                      object:self];

    [self.tableView reloadData];
  }
}

@end
