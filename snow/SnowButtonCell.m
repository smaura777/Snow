//
//  SnowButtonCell.m
//  snow
//
//  Created by samuel maura on 5/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowButtonCell.h"

@implementation SnowButtonCell

- (void)awakeFromNib {
  // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:reuseIdentifier];

  CGRect inFrame = CGRectInset(self.bounds, 20, 2);
  _button = [[UIButton alloc] initWithFrame:inFrame];
  //_button.layer.borderWidth = 1;

  //_button.layer.borderColor = [UIColor redColor].CGColor;

  _button.layer.cornerRadius = 5;
  //[_button setTitle:@"EDIT" forState:UIControlStateNormal];

  [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  [_button setTitleColor:[UIColor blackColor]
                forState:UIControlStateHighlighted];
  [self.contentView addSubview:_button];

  return self;
}

- (void)layoutSubviews {
  // self.opaque = YES;
  // _edit.frame = CGRectInset(self.frame, 2, 2);
  CGRect inFrame = CGRectInset(self.bounds, 20, 2);

  _button.frame = inFrame; // CGRectMake(150, 0, 200, 50);;
                           
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
