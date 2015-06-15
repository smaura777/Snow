//
//  SnowListCreateTVC.m
//  snow
//
//  Created by samuel maura on 3/28/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowListCreateTVC.h"
#import "SnowDataManager.h"
#import "SnowTableViewController.h"

@interface SnowListCreateTVC ()

@end

@implementation SnowListCreateTVC {
  UIBarButtonItem *_saveButton;
  // NSString *_listName;
}

- (void)viewDidLoad {
  [super viewDidLoad];

   self.title = @"Add new list";
    
  [self.tableView registerClass:[SnowSimpleTextFieldCell class]
         forCellReuseIdentifier:@"SnowSimpleTextFieldCell"];

  _saveButton = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                           target:self
                           action:@selector(saveListAction:)];

  self.navigationItem.rightBarButtonItem = _saveButton;

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                           target:self
                           action:@selector(cancelAction:)];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation
  // bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;

  _saveButton.enabled = NO;

  /*
  _textViewCell.backgroundColor =  [UIColor colorWithRed:.12
                                                   green:.12
                                                    blue:.12
                                                   alpha:.7];

  _ListName.backgroundColor =
  [UIColor colorWithRed:.12
                  green:.12
                   blue:.12
                  alpha:.7];

   */

  //[[SnowAppearanceManager sharedInstance]
  // currentTheme].ternary;
  // _textView.alpha = 0.5;

  /**

  _textViewCell.backgroundColor =
      [UIColor colorWithRed:0.12
                      green:0.12
                       blue:0.12
                      alpha:.7];

  _ListName.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:@"enter list name"
          attributes:@{
            NSForegroundColorAttributeName :
                [UIColor colorWithRed:1 green:1 blue:1 alpha:.7]
          }];

  _ListName.textColor = [UIColor whiteColor];

  _ListName.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  [_ListName becomeFirstResponder];

  **/
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.tableView.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - table stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  SnowSimpleTextFieldCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"SnowSimpleTextFieldCell"
                                      forIndexPath:indexPath];

  UIColor *textColor = [UIColor whiteColor];
  UIColor *placeholderColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  UIColor *bg = [UIColor colorWithRed:.12 green:.12 blue:.12 alpha:1];

  cell.backgroundColor = bg;
  cell.textField.backgroundColor = [UIColor clearColor];

  [cell setupWithPlaceHolder:@"enter list name"
            PlaceHolderColor:placeholderColor
                AndTextColor:textColor];

  cell.textField.delegate = self;

    _ListName = cell.textField;
    
  return cell;
}

#pragma mark - Actions

- (void)cancelAction:(id)sender {
  [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveListAction:(id)sender {

  NSString *value =
      [_ListName.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]];

  if ([value length] > 0) {

    [self.parentViewController dismissViewControllerAnimated:YES
                                                  completion:^{
                                                    self.saveList(value);
                                                  }];
  }
}

#pragma mark - TextFieldDelegate

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  if ([string length] > 0 ) {
    _saveButton.enabled = YES;
  }
  else if ( ([string length] == 0) && ([textField.text length] > 1) ){
      _saveButton.enabled = YES;
  }
  else {
    _saveButton.enabled = NO;
  }

  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

@end
