//
//  SnowSimpleTextFieldCell.m
//  snow
//
//  Created by samuel maura on 6/8/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowSimpleTextFieldCell.h"

@implementation SnowSimpleTextFieldCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

  _textField = [[UITextField alloc] init];

  return self;
}

- (void)setupWithPlaceHolder:(NSString *)placeholder
            PlaceHolderColor:(UIColor *)placeholderColor
                AndTextColor:(UIColor *)textColor {

  _textField.attributedPlaceholder = [[NSAttributedString alloc]
      initWithString:placeholder
          attributes:@{NSForegroundColorAttributeName : placeholderColor}];
  _textField.textColor = textColor;
  _textField.borderStyle = UITextBorderStyleNone;

  [self.contentView addSubview:_textField];

  _textField.translatesAutoresizingMaskIntoConstraints = NO;

  [self.contentView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_textField
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:10]];

  [self.contentView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_textField
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.contentView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:-10]];

  [self.contentView
      addConstraint:[NSLayoutConstraint constraintWithItem:_textField
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.contentView
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:1]];

  [self.contentView addConstraint:[NSLayoutConstraint
                                      constraintWithItem:_textField
                                               attribute:NSLayoutAttributeBottom
                                               relatedBy:NSLayoutRelationEqual
                                                  toItem:self.contentView
                                               attribute:NSLayoutAttributeBottom
                                              multiplier:1
                                                constant:1]];
}

@end
