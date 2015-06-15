//
//  SnowCellTypeA1.m
//  snow
//
//  Created by samuel maura on 5/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowCellTypeA1.h"
#import "SnowAppearanceManager.h"

@implementation SnowCellTypeA1 {
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  // self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

  self = [super initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:reuseIdentifier];

  //self.backgroundColor = [UIColor blackColor];

  return self;
}

- (void)setup {
  CGRect inFrame = CGRectInset(self.bounds, 0, 0);
  //[UIImage imageNamed:@"snow_stack_filled-50"]
  _menuButton = [[SnowButtonTypeA2 alloc] init];
  [_menuButton customizeForType:0];

  [_menuButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];

  [_menuButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
  /*
    [_menuButton
        setImage:[UIImage getTintedImage:[UIImage imageNamed:_buttonImage]
                               withColor:[UIColor colorWithHue:0.5
                                                    saturation:1
                                                    brightness:1
                                                         alpha:1]]
        forState:UIControlStateNormal];

      */

  [_menuButton
      setImage:[UIImage getTintedImage:[UIImage imageNamed:_buttonImage]
                             withColor:[[SnowAppearanceManager
                                                sharedInstance] currentTheme]
                                           .textColor]
      forState:UIControlStateNormal];

  _menuButton.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentLeft;

  //  _menuButton.tintColor = [UIColor redColor];

  if (_buttonLabel) {
    [_menuButton setTitle:_buttonLabel forState:UIControlStateNormal];
    [_menuButton setTitle:_buttonLabel forState:UIControlStateHighlighted];

  } else {
    [_menuButton setTitle:@"no title" forState:UIControlStateNormal];
    [_menuButton setTitle:@"no title" forState:UIControlStateHighlighted];
  }

  _menuButton.frame = inFrame;

  [self.contentView addSubview:_menuButton];
}

- (void)layoutSubviews {
  CGRect inFrame = CGRectInset(self.bounds, 0, 0);

  NSLog(@"Layout subview called for %@", _buttonLabel);

  _menuButton.frame = inFrame;
}

@end
