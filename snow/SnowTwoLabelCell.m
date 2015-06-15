//
//  SnowTwoLabelCell.m
//  snow
//
//  Created by samuel maura on 5/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowTwoLabelCell.h"

@implementation SnowTwoLabelCell

- (void)awakeFromNib {
  // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleValue2
              reuseIdentifier:reuseIdentifier];

  _title = [[UILabel alloc] init];
  _value = [[UILabel alloc] init];
  _title.textAlignment = NSTextAlignmentLeft;
  _value.textAlignment = NSTextAlignmentCenter;
  _title.textColor = [UIColor whiteColor];
  _value.textColor = [UIColor whiteColor];

  //_title.layer.borderWidth =2;
  //_title.layer.borderColor = [UIColor redColor].CGColor;

  //_value.layer.borderWidth =2;
  //_value.layer.borderColor = [UIColor redColor].CGColor;

  [self addSubview:_title];
  [self addSubview:_value];

  _title.translatesAutoresizingMaskIntoConstraints = NO;
  _value.translatesAutoresizingMaskIntoConstraints = NO;

  // Title constraints

  [self addConstraint:[NSLayoutConstraint
                          constraintWithItem:_title
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeLeading
                                  multiplier:1
                                    constant:16]];

  [self
      addConstraint:[NSLayoutConstraint constraintWithItem:_title
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:2]];

  [self addConstraint:[NSLayoutConstraint
                          constraintWithItem:_title
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                    constant:2]];

  // Value constraints

  [self addConstraint:[NSLayoutConstraint
                          constraintWithItem:_value
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeTrailing
                                  multiplier:1
                                    constant:-16]];

  [self
      addConstraint:[NSLayoutConstraint constraintWithItem:_value
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:2]];

  [self addConstraint:[NSLayoutConstraint
                          constraintWithItem:_value
                                   attribute:NSLayoutAttributeBottom
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self
                                   attribute:NSLayoutAttributeBottom
                                  multiplier:1
                                    constant:-2]];
    /*
  [_value
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_value
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:60]];
     */
    

  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
