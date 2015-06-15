//
//  SnowCellA.m
//  snow
//
//  Created by samuel maura on 4/9/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowCellA.h"

@implementation SnowCellA

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:reuseIdentifier];
  NSLog(@"Cell A style %ld", style);

  self.selectionStyle = UITableViewCellSelectionStyleGray;

//  UIPanGestureRecognizer *pan =
//      [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                              action:@selector(panning:)];

  UISwipeGestureRecognizer *swipe =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(swipping:)];

  // [self addGestureRecognizer:pan];
  [self addGestureRecognizer:swipe];

  return self;
}

- (void)panning:(UIPanGestureRecognizer *)sender {
  NSLog(@"Panning .... *********************");
}

- (void)swipping:(UISwipeGestureRecognizer *)sender {
  NSLog(@"Swipping .... *********************");
}

@end
