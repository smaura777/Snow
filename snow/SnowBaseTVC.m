//
//  SnowBaseTVC.m
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowBaseTVC.h"

@interface SnowBaseTVC ()

@end

@implementation SnowBaseTVC

- (void)viewDidLoad {
  [super viewDidLoad];

  _closeBt = [UIImage
      getTintedImage:[UIImage imageNamed:@"snow_menu_close"]
           withColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                         .primary];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

 /*
  NSDictionary *titleAttributes = @{
    NSFontAttributeName :
        [UIFont fontWithName:@"AvenirNextCondensed-Medium" size:14.0],
    NSForegroundColorAttributeName : [UIColor whiteColor]
  };

  self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
  */
    
}

- (void)viewWillAppear:(BOOL)animated {
  [self applyTheme];

  // Setup background change notifications

  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //                                             selector:@selector(updateBackground:)
  //                                                 name:@"SnowBackgroundUpdate"
  //                                               object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateAppearance:)
                                               name:@"SnowThemeUpdate"
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:@"SnowThemeUpdate"
                                                object:nil];
}

- (void)updateAppearance:(NSNotification *)note {
  [self applyTheme];

  if (note) {
    [self.tableView reloadData];
  }
}

- (void)applyTheme {

  UIColor *tableBC =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  UIColor *navBarBC =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  UIImage *navBarBI = [UIImage imageWithColor:navBarBC];

  UIColor *navBarTintC =
      [[SnowAppearanceManager sharedInstance] currentTheme].secondary;

  // [UIView animateWithDuration:.5 animations:^{

  [self.navigationController.navigationBar
      setBackgroundImage:navBarBI
           forBarMetrics:UIBarMetricsDefault];

  //[self.navigationController.navigationBar setShadowImage:[UIImage new]];

  [self.navigationController.navigationBar setTintColor:navBarTintC];

  [self.tableView setBackgroundColor:tableBC];

  [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)showEmptyTable:(UITableView *)table
          ForContainer:(UIView *)container
           WithMessage:(NSString *)msg
          AndTextColor:(UIColor *)textColor {
  CGRect labelFrame = CGRectMake(0, 0, container.bounds.size.width,
                                 container.bounds.size.height);

  if (_emptyLabel) {
    // update frame only

    if ([table.backgroundView isKindOfClass:[UILabel class]]) {
      _emptyLabel.frame = container.bounds;
    } else {
      _emptyLabel.frame = table.backgroundView.bounds;
    }

    return;
  }

  _emptyLabel = [[UILabel alloc] initWithFrame:labelFrame];

  if ([msg length] > 0) {
    _emptyLabel.text = msg;
  } else {
    _emptyLabel.text = @"No Data found";
  }

  _emptyLabel.numberOfLines = 0;
  _emptyLabel.textAlignment = NSTextAlignmentCenter;

  if (textColor) {
    _emptyLabel.textColor = textColor;
  } else {
    _emptyLabel.textColor = [UIColor blackColor];
  }

  _emptyLabel.font = [UIFont fontWithName:@"Palatino-italic" size:24];
  [_emptyLabel sizeToFit];

  if (table.backgroundView == nil) {
    table.backgroundView = _emptyLabel;
  } else {
    // add as a subview

    _emptyLabel.backgroundColor =
        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.39];
    _emptyLabel.frame = table.backgroundView.bounds;

    [table.backgroundView addSubview:_emptyLabel];
  }
}

- (void)showEmptyDataMessageIfNeeded:(NSInteger)sec_count
                             WithMsg:(NSString *)msg
                            AndLabel:(UILabel *)msgLabel {

  if (sec_count == 0) {
    NSLog(@"You have not created any tasks yet %@ ",
          self.tableView.backgroundView);
    if (self.tableView.backgroundView == nil) {

      msgLabel.frame = self.tableView.frame;
      msgLabel.textAlignment = NSTextAlignmentCenter;
      msgLabel.font =
          [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
      msgLabel.textColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:.7];
      msgLabel.text = msg;
      self.tableView.backgroundView = msgLabel;
    } else {
      // Update label text only
      msgLabel.text = msg;
    }

  } else {
    self.tableView.backgroundView = nil;
  }
}

- (void)showAlertWithTitle:(NSString *)title AndMessage:(NSString *)msg {

  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:title
                                          message:msg
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *action1 =
      [UIAlertAction actionWithTitle:@"close"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action){

                             }];

  [alert addAction:action1];

  [self presentViewController:alert animated:YES completion:nil];
}

@end
