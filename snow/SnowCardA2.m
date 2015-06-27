//
//  SnowCardA2.m
//  snow
//
//  Created by samuel maura on 6/5/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowCardA2.h"
#import "SnowAppearanceManager.h"
#import "UIImage+SnowImageUtils.h"

@implementation SnowCardA2

- (void)awakeFromNib {
  // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

  [self setupCell];

  [self enableCellActions];

  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)doSheet:(id)sender {

  [_delegate cell:self ActionButtonPressedFor:_task AtIndex:_cellPath];
}

- (void)enableCellActions {

  [self.taskOptions addTarget:self
                       action:@selector(doSheet:)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupCell {

  self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
  // self.layer.borderWidth = 1;
  // self.layer.borderColor = [UIColor colorWithRed:.9 green:.3 blue:.3
  // alpha:1].CGColor;

  _dataContainerView = [[UIView alloc] init];

  // _dataContainerView.backgroundColor = [UIColor colorWithRed:.9 green:0
  // blue:0 alpha:1];

  [self.contentView addSubview:_dataContainerView];

  _dataContainerView.layer.masksToBounds = NO;
  //_dataContainerView.layer.cornerRadius = 8; // if you like rounded corners
  _dataContainerView.layer.shadowOffset = CGSizeMake(0, 0);
  _dataContainerView.layer.shadowRadius = 2;
  _dataContainerView.layer.shadowOpacity = 0.5;

  // Task Title ======================================

  _taskTitle = [[UILabel alloc] init];
  //_taskTitle.textColor = [UIColor whiteColor];
  _taskTitle.textAlignment = NSTextAlignmentLeft;
  _taskTitle.numberOfLines = 0;
  [_taskTitle setPreferredMaxLayoutWidth:150]; // MAY NEED TO CHANGE THIS FOR
                                               // LARGER SCREENS
  _taskTitle.font =
      [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
  //[UIFont fontWithName:@"AvenirNext-Medium" size:17];

  // _taskTitle.layer.borderWidth = 1;
  // _taskTitle.layer.borderColor = [UIColor blackColor].CGColor;

  [_dataContainerView addSubview:_taskTitle];

  // Action view ====================================

  _actionView = [[UIView alloc] init];
  // _actionView.backgroundColor = [UIColor colorWithRed:.8 green:.8 blue:.8
  // alpha:.10];
  [_dataContainerView addSubview:_actionView];

  // Due Label ===========================
  _dueDate = [[UILabel alloc] init];
  //_dueDate.textColor = [UIColor whiteColor];
  _dueDate.textAlignment = NSTextAlignmentLeft;
  _dueDate.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
  //[UIFont fontWithName:@"AvenirNextCondensed-Regular" size:12];
  [_actionView addSubview:_dueDate];

  // TaskOptions button
  _taskOptions = [[UIButton alloc] init];

  [_taskOptions
      setImage:[UIImage getTintedImage:[UIImage imageNamed:@"snow_more"]
                             withColor:[UIColor darkGrayColor]]
      forState:UIControlStateNormal];
    
   // _taskOptions.layer.borderWidth = 1.0;
   // _taskOptions.layer.borderColor = [UIColor blackColor].CGColor;
    
  /*
[_taskOptions setImage:[UIImage imageNamed:@"snow_more"]
              forState:UIControlStateNormal];
 */

  [_actionView addSubview:_taskOptions];

  [self setupCellLayput];
}

- (void)setupCellLayput {

  _taskOptions.translatesAutoresizingMaskIntoConstraints = NO;
  _dueDate.translatesAutoresizingMaskIntoConstraints = NO;
  _taskTitle.translatesAutoresizingMaskIntoConstraints = NO;
  _actionView.translatesAutoresizingMaskIntoConstraints = NO;
  _dataContainerView.translatesAutoresizingMaskIntoConstraints = NO;

  // CONTAINER LAYOUT  =========================================

  /*

    [_dataContainerView addConstraint:[NSLayoutConstraint
    constraintWithItem:_dataContainerView attribute:NSLayoutAttributeWidth
    relatedBy:NSLayoutRelationEqual toItem:nil
    attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200]];
  */

  /*
  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_dataContainerView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50]];
*/

  [self.contentView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_dataContainerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:5]];

  [self.contentView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_dataContainerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-5]];

  [self.contentView
      addConstraint:[NSLayoutConstraint constraintWithItem:_dataContainerView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.contentView
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:.3]];

  [self.contentView addConstraint:[NSLayoutConstraint
                                      constraintWithItem:_dataContainerView
                                               attribute:NSLayoutAttributeBottom
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.contentView
                                               attribute:NSLayoutAttributeBottom
                                              multiplier:1
                                                constant:0]];

  // ACTION VIEW LAYOUT  =========================================

  [_actionView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_actionView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:44]];

  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_actionView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_dataContainerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:0]];

  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_actionView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_dataContainerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:0]];

  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_actionView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_dataContainerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0]];

  // TITLE LABEL LAYOUT  =========================================

  /*
  [_taskTitle
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskTitle
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50]];
*/
  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskTitle
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_dataContainerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:10]];

  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskTitle
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_dataContainerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-10]];

  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskTitle
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:_dataContainerView
                                 attribute:NSLayoutAttributeTop
                                multiplier:2
                                  constant:20]];

  [_dataContainerView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskTitle
                                 attribute:NSLayoutAttributeBaseline
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_actionView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:-10]];

  // Due label ===================================

  [_actionView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_dueDate
                                          attribute:NSLayoutAttributeLeading
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:_actionView
                                          attribute:NSLayoutAttributeLeading
                                         multiplier:1
                                           constant:10]];

  [_actionView
      addConstraint:[NSLayoutConstraint constraintWithItem:_dueDate
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_actionView
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:0]];

  [_actionView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_dueDate
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:_actionView
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];

  /*
  [_dueDate
   addConstraint:[NSLayoutConstraint
                  constraintWithItem:_dueDate
                  attribute:NSLayoutAttributeWidth
                  relatedBy:NSLayoutRelationEqual
                  toItem:nil
                  attribute:NSLayoutAttributeNotAnAttribute
                  multiplier:1
                  constant:100]];

  */

  // taskOptions button ========================================

  [_actionView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_taskOptions
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:_actionView
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1
                                           constant:-20]];

  [_actionView
      addConstraint:[NSLayoutConstraint constraintWithItem:_taskOptions
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_actionView
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:0]];

  [_taskOptions
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskOptions
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50]];

  [_taskOptions
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_taskOptions
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:50]];

  [_actionView addConstraint:[NSLayoutConstraint
                                 constraintWithItem:_taskOptions
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:_actionView
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                           constant:0]];
}

@end
