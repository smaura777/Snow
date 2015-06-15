//
//  SnowButtonTypeA1.m
//  snow
//
//  Created by samuel maura on 5/27/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowButtonTypeA1.h"




@implementation SnowButtonTypeA1 {
  BOOL _blinkON;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
  self = [super init];

  if (self) {
    _blinkON = NO;
  }

  return self;
}


-(void)customizeForType:(NSUInteger)type{
    
    UIColor *btBorderColor = [[SnowAppearanceManager sharedInstance] currentTheme].primary;
    /*
    [UIColor colorWithHue:0.5
                                         saturation:1 brightness:1 alpha:0.10];
    */
   UIColor *btTextColor = [[SnowAppearanceManager sharedInstance] currentTheme].primary;
    /*
    [UIColor colorWithHue:0.5 saturation:1
               brightness:1 alpha:1];
    */
   UIColor *btTextColorSelected  = [UIColor colorWithHue:1
               saturation:0 brightness:1 alpha:1];
   UIFont *bf = [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:72];
    
   CGFloat borderWidth = 0;
    
    
    switch (type) {
        case 0:{
            self.titleLabel.font = bf;
            self.layer.borderWidth = borderWidth;
            self.layer.borderColor = [UIColor colorWithHue:0.5 saturation:1 brightness:1 alpha:0].CGColor;  //btBorderColor.CGColor;
            [self setTitleColor:btTextColor forState:UIControlStateNormal];
            [self setTitleColor:btTextColorSelected  forState:UIControlStateHighlighted];
            
            [self setBackgroundImage:[UIImage imageWithColor:btTextColor]
                                forState:UIControlStateHighlighted];
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
  NSLog(@"Dealloc called for %s ", __func__);
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)listen:(BOOL)status {
    
  if (status == _blinkON) {
    return;
  }
    
   NSLog(@" %s :Setting button listening status to %d",__func__,status);

  _blinkON = status;

  if (_blinkON) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(blink:)
                                                 name:@"SNOW_ACTIVE_TIMERS"
                                               object:nil];

  } else {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }
}

- (void)blink:(NSNotification *)note {

  NSLog(@"Received %@ in %s", note.name, __func__);

  __weak typeof(self) weakSelf = self;

    UIColor *bc_on = [[SnowAppearanceManager sharedInstance] currentTheme].primary;
      //[UIColor colorWithHue:0.5 saturation:1 brightness:0.7 alpha:0.7];
  UIColor *bc_off =
      [UIColor colorWithHue:0.5 saturation:1 brightness:1 alpha:0];

  [UIView animateWithDuration:0.5
      delay:0.5
      options:UIViewAnimationOptionCurveEaseIn |
              UIViewAnimationOptionAllowUserInteraction
      animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.backgroundColor = bc_on;
      }
      completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [UIView animateWithDuration:0.5
                              delay:0.5
                            options:UIViewAnimationOptionCurveEaseOut |
                                    UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                           strongSelf.backgroundColor = bc_off;
                             
                         }
                         completion:nil];

      }];
}

@end
