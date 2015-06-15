//
//  SimpleTextViewCell.m
//  snow
//
//  Created by samuel maura on 3/28/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SimpleTextViewCell.h"
#import "SnowAppearanceManager.h"

@implementation SimpleTextViewCell

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

  CGRect cellFrame =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  UITextView *theView = [[UITextView alloc] initWithFrame:cellFrame];

  _textView = theView;

    
  _textView.backgroundColor =
      [UIColor colorWithRed:.12
                      green:.12
                       blue:.12
                      alpha:.7]; //[[SnowAppearanceManager sharedInstance]
                                 //currentTheme].ternary;
                                 // _textView.alpha = 0.5;
  _textView.textColor = [UIColor whiteColor];

   _textView.font = [UIFont fontWithName:@"AvenirNext-Medium" size:18];
    
  [self.contentView addSubview:_textView];

  return self;
}

- (void)layoutSubviews {
  _textView.frame =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
