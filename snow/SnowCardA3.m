//
//  SnowCardA3.m
//  snow
//
//  Created by samuel maura on 6/9/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowCardA3.h"

@implementation SnowCardA3

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setupCell {

  self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
  // self.layer.borderWidth = 1;
  // self.layer.borderColor = [UIColor colorWithRed:.9 green:.3 blue:.3
  // alpha:1].CGColor;

  self.dataContainerView = [[UIView alloc] init];

  // _dataContainerView.backgroundColor = [UIColor colorWithRed:.9 green:0
  // blue:0 alpha:1];

  [self.contentView addSubview:self.dataContainerView];

  self.dataContainerView.layer.masksToBounds = NO;
  //_dataContainerView.layer.cornerRadius = 8; // if you like rounded corners
  self.dataContainerView.layer.shadowOffset = CGSizeMake(0, 0);
  self.dataContainerView.layer.shadowRadius = 2;
  self.dataContainerView.layer.shadowOpacity = 0.5;

  // Task Title ======================================

  self.taskTitle = [[UILabel alloc] init];
  self.taskTitle.textAlignment = NSTextAlignmentLeft;
  self.taskTitle.numberOfLines = 0;
  [self.taskTitle
      setPreferredMaxLayoutWidth:150]; // MAY NEED TO CHANGE THIS FOR
  // LARGER SCREENS
  self.taskTitle.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

  [self.dataContainerView addSubview:self.taskTitle];

  // Action view ====================================

  self.actionView = [[UIView alloc] init];
  [self.dataContainerView addSubview:self.actionView];

  // Due Label ===========================
  self.dueDate = [[UILabel alloc] init];
  self.dueDate.textAlignment = NSTextAlignmentLeft;
  self.dueDate.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
  //[UIFont fontWithName:@"AvenirNextCondensed-Regular" size:12];
  [self.actionView addSubview:self.dueDate];

  // TaskOptions button
  self.taskOptions = nil; //[[UIButton alloc] init];

  [self setupCellLayput];
}

- (void)setupCellLayput {

  //_taskOptions.translatesAutoresizingMaskIntoConstraints = NO;
  self.dueDate.translatesAutoresizingMaskIntoConstraints = NO;
  self.taskTitle.translatesAutoresizingMaskIntoConstraints = NO;
  self.actionView.translatesAutoresizingMaskIntoConstraints = NO;
  self.dataContainerView.translatesAutoresizingMaskIntoConstraints = NO;

  // CONTAINER LAYOUT  =========================================

  [self.contentView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.dataContainerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:5]];

  [self.contentView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.dataContainerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-5]];

  [self.contentView addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.dataContainerView
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.contentView
                                               attribute:NSLayoutAttributeTop
                                              multiplier:1
                                                constant:.3]];

  [self.contentView addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.dataContainerView
                                               attribute:NSLayoutAttributeBottom
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.contentView
                                               attribute:NSLayoutAttributeBottom
                                              multiplier:1
                                                constant:0]];

  // ACTION VIEW LAYOUT  =========================================

  [self.actionView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.actionView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:44]];

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.actionView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.dataContainerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:0]];

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.actionView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.dataContainerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:0]];

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.actionView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.dataContainerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0]];

  // TITLE LABEL LAYOUT  =========================================

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.taskTitle
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.dataContainerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:10]];

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.taskTitle
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.dataContainerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-10]];

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.taskTitle
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:self.dataContainerView
                                 attribute:NSLayoutAttributeTop
                                multiplier:2
                                  constant:20]];

  [self.dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.taskTitle
                                 attribute:NSLayoutAttributeBaseline
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.actionView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:-10]];

  // Due label ===================================

  [self.actionView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.dueDate
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.actionView
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1
                                               constant:10]];

  [self.actionView
      addConstraint:[NSLayoutConstraint constraintWithItem:self.dueDate
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.actionView
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:0]];

  [self.actionView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.dueDate
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.actionView
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1
                                               constant:0]];
}

@end
