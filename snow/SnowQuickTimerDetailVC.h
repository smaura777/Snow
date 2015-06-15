//
//  SnowQuickTimerDetailVC.h
//  snow
//
//  Created by samuel maura on 5/21/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowTimer.h"

@interface SnowQuickTimerDetailVC : UIViewController

@property(nonatomic, strong) SnowTimer *timer;
@property(nonatomic, strong) NSTimer *timerEngine;
@property(nonatomic, strong) NSDate *fireDate;

@end
