//
//  SnowQuickTimerDetailVC.m
//  snow
//
//  Created by samuel maura on 5/21/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowQuickTimerDetailVC.h"

@interface SnowQuickTimerDetailVC ()

@end

@implementation SnowQuickTimerDetailVC {
  UILabel *_timerLabel;
  int _secondsLeft;
  UIButton *_pauseTimerButton, *_cancelTimerButton;
  BOOL _isTimerStopped;
  BOOL _isTimerPaused;

  UIView *_controlArea;
}

- (void)setup {

  self.view.alpha = 1;
  self.view.backgroundColor = [UIColor blackColor];

  CGRect labelFrame = CGRectInset(self.view.frame, 20, 80);
  _timerLabel = [[UILabel alloc] initWithFrame:labelFrame];
  _timerLabel.textAlignment = NSTextAlignmentCenter;

  _timerLabel.text = @"HELLO, THERE";
  _timerLabel.textColor = [UIColor whiteColor];
  _timerLabel.backgroundColor = [UIColor blackColor];

  _pauseTimerButton = [[UIButton alloc] init];
  _cancelTimerButton = [[UIButton alloc] init];

  [_pauseTimerButton addTarget:self
                        action:@selector(pauseResumeTimerToggle)
              forControlEvents:UIControlEventTouchUpInside];
  [_cancelTimerButton addTarget:self
                         action:@selector(stopRestartTimer)
               forControlEvents:UIControlEventTouchUpInside];

  [_pauseTimerButton setTitle:@"pause" forState:UIControlStateNormal];
  [_cancelTimerButton setTitle:@"stop" forState:UIControlStateNormal];

  [_pauseTimerButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
  [_cancelTimerButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];

  _isTimerStopped = NO;
  _isTimerPaused = NO;

  _controlArea = [[UIView alloc] init];
  //_controlArea.backgroundColor =[UIColor darkGrayColor];

  [self.view addSubview:_timerLabel];

  [_controlArea addSubview:_cancelTimerButton];
  [_controlArea addSubview:_pauseTimerButton];

  [self.view addSubview:_controlArea];
}

- (void)showTimer {

  if (_secondsLeft > 0) {

    int hour = _secondsLeft / 3600;
    int minutes = (_secondsLeft % 3600) / 60;
    int seconds = (_secondsLeft % 3600) % 60;

    _timerLabel.text =
        [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];

    --_secondsLeft;

  } else {
    _pauseTimerButton.enabled = NO;
    [_cancelTimerButton setTitle:@"restart" forState:UIControlStateNormal];

    [_timerEngine invalidate];

    _timerLabel.text = [NSString stringWithFormat:@"00:00:00", nil];
    // NSLog(@"Timer invalidated");
  }
}

- (void)startTimer {
}

- (void)pauseResumeTimerToggle {

  _isTimerPaused = !_isTimerPaused;

  if (_isTimerPaused) {

    _cancelTimerButton.enabled = NO;

    [_timerEngine invalidate];
    [_pauseTimerButton setTitle:@"resume" forState:UIControlStateNormal];
  } else {
    _timerEngine = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(showTimer)
                                                  userInfo:nil
                                                   repeats:YES];

    _cancelTimerButton.enabled = YES;

    [_pauseTimerButton setTitle:@"pause" forState:UIControlStateNormal];
  }
}

- (void)stopRestartTimer {

  _isTimerStopped = !_isTimerStopped;

  if (_isTimerStopped) {
    _pauseTimerButton.enabled = NO;
    [_timerEngine invalidate];
    [_cancelTimerButton setTitle:@"restart" forState:UIControlStateNormal];
  } else {
    _secondsLeft = (int)_timer.timerValue;
    _timerEngine = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(showTimer)
                                                  userInfo:nil
                                                   repeats:YES];
    _pauseTimerButton.enabled = YES;
    [_cancelTimerButton setTitle:@"stop" forState:UIControlStateNormal];
  }
}

- (void)viewDidLayoutSubviews {

  CGRect bottomRect = CGRectMake(0, self.view.bounds.size.height - 80,
                                 self.view.bounds.size.width, 80);

  _controlArea.frame = bottomRect;

  _pauseTimerButton.frame = CGRectMake(50, 20, 100, 40);
  _cancelTimerButton.frame = CGRectMake(160, 20, 100, 40);

  _timerLabel.frame = CGRectInset(self.view.frame, 20, 80);
}

- (void)viewWillDisappear:(BOOL)animated {
  [_timerEngine invalidate];
  // NSLog(@"Timer invalidated");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self setup];
  _secondsLeft = (int)_timer.timerValue;
  _fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:_timer.timerValue];

  NSDateFormatter *df = [[NSDateFormatter alloc] init];
  [df setDateFormat:@"EEEE, MMMM d, YYYY hh:mm:ss a"];

  // NSLog(@"Timer expires on %@", [df stringFromDate:_fireDate]);

  _timerEngine.tolerance = 0.1;

  _timerEngine = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(showTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)createLocalNotificationForTimer {
}

- (void)clearLocalNotificationForTimer {
}

- (void)saveActiveTimer {
}

@end
