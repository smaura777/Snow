//
//  SnowQuickTimerVC.m
//  snow
//
//  Created by samuel maura on 5/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowQuickTimerVC.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#define STM_buttonBorderColor                                                  \
  [UIColor colorWithHue:0.5 saturation:1 brightness:1 alpha:0.10];

#define STM_buttonTextColor                                                    \
  [UIColor colorWithHue:0.5 saturation:1 brightness:1 alpha:1];

#define STM_buttonTextColorSelected                                            \
  [UIColor colorWithHue:1 saturation:0 brightness:1 alpha:1];

@interface SnowQuickTimerVC ()

@end

@implementation SnowQuickTimerVC {
  SnowButtonTypeA1 *_timer45;
  SnowButtonTypeA1 *_timer25;
  SnowButtonTypeA1 *_timer5;
  SnowButtonTypeA1 *_timer15;
  SnowButtonTypeA1 *_timer10;
  SnowButtonTypeA1 *_timer30;
  SnowButtonTypeA1 *_timer90;
  SnowButtonTypeA1 *_timer180;

  UIView *_timerSettings;
  // UIVisualEffectView
  UIView *_timerCountDown;
  UIView *_buttonContainer;

  UILabel *_timerLabel;
  int _secondsLeft;
  UIButton *_pauseTimerButton, *_cancelTimerButton, *_timerComplete;
  BOOL _isTimerPaused;
  UIView *_controlArea;

  SnowTimer *_timerObject;
  NSTimer *_timerEngine;
  AVAudioPlayer *_aPlayer;
  NSTimer *showActiveTimerIndicators_timer;
  NSTimeInterval _secondsLeft45, _secondsLeft25, _secondsLeft5, _secondsLeft15,
      _secondsLeft10, _secondsLeft90;

  BOOL _countDownViewIsOn;
  BOOL _backgroundModeOn;
}

static NSString *SnowActiveTimersPresent = @"SNOW_ACTIVE_TIMERS";
static NSString *SnowActiveTimersOff = @"SNOW_INAACTIVE_TIMERS";

- (void)setup {
  CGRect timerSettingsRect = self.view.bounds;

  self.view.backgroundColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  // Countdown
  _timerCountDown = [[UIView alloc] initWithFrame:timerSettingsRect];
  //[[UIVisualEffectView alloc] initWithEffect:UIBlurEffectStyleExtraLight];
  _timerCountDown.frame = timerSettingsRect;

  _timerCountDown.tag = 2;

  _timerCountDown.backgroundColor =
      [UIColor colorWithRed:1 green:1 blue:1 alpha:.9];

  [self.view addSubview:_timerCountDown];

  // timer pad
  _timerSettings = [[UIView alloc] initWithFrame:timerSettingsRect];
  _timerSettings.tag = 1;

  _timerSettings.backgroundColor =
      [UIColor colorWithRed:1 green:1 blue:1 alpha:.90];
  [self.view addSubview:_timerSettings];
}

- (void)setupTimerButtons {

  CGRect timerRect25 = CGRectMake(0, 0, 80, 100);
  CGRect timerRect45 = CGRectMake(81, 0, 80, 80);
  CGRect timerRect5 = CGRectMake(161, 0, 80, 100);

  CGRect timerRect10 = CGRectMake(0, 101, 80, 80);
  CGRect timerRect15 = CGRectMake(81, 101, 80, 100);
  CGRect timerRect90 = CGRectMake(161, 101, 80, 80);

  CGRect buttonContainerFrame =
      _timerSettings.bounds; // CGRectMake(0, 0, 300, 401);

  _buttonContainer = [[UIView alloc] init];
  _buttonContainer.frame = buttonContainerFrame;
  /*
  _buttonContainer.backgroundColor =
      [UIColor colorWithHue:1 saturation:1 brightness:0 alpha:1];
   */

  _timer25 = [[SnowButtonTypeA1 alloc] init];
  [_timer25 customizeForType:0];
  [_timer25 setTitle:@"25" forState:UIControlStateNormal];
  _timer25.frame = timerRect25;

  _timer45 = [[SnowButtonTypeA1 alloc] init];
  [_timer45 customizeForType:0];
  [_timer45 setTitle:@"45" forState:UIControlStateNormal];
  _timer45.frame = timerRect45;

  _timer5 = [[SnowButtonTypeA1 alloc] init];
  [_timer5 setTitle:@"5" forState:UIControlStateNormal];
  [_timer5 customizeForType:0];
  _timer5.frame = timerRect5;

  _timer10 = [[SnowButtonTypeA1 alloc] init];
  [_timer10 customizeForType:0];
  [_timer10 setTitle:@"10" forState:UIControlStateNormal];
  _timer10.frame = timerRect10;

  _timer15 = [[SnowButtonTypeA1 alloc] init];
  [_timer15 customizeForType:0];
  [_timer15 setTitle:@"15" forState:UIControlStateNormal];
  _timer15.frame = timerRect15;

  _timer90 = [[SnowButtonTypeA1 alloc] init];
  [_timer90 customizeForType:0];
  [_timer90 setTitle:@"90" forState:UIControlStateNormal];
  _timer90.frame = timerRect90;

  // button tags

  _timer25.tag = 25;
  _timer45.tag = 45;
  _timer15.tag = 15;
  _timer5.tag = 5;
  _timer10.tag = 10;
  _timer90.tag = 90;

  [_timerSettings addSubview:_buttonContainer];

  [_buttonContainer addSubview:_timer25];
  [_buttonContainer addSubview:_timer45];
  [_buttonContainer addSubview:_timer5];
  [_buttonContainer addSubview:_timer10];
  [_buttonContainer addSubview:_timer15];
  [_buttonContainer addSubview:_timer90];

  // targets

  [_timer25 addTarget:self
                action:@selector(timerButtonTapped:)
      forControlEvents:UIControlEventTouchUpInside];

  [_timer45 addTarget:self
                action:@selector(timerButtonTapped:)
      forControlEvents:UIControlEventTouchUpInside];

  [_timer5 addTarget:self
                action:@selector(timerButtonTapped:)
      forControlEvents:UIControlEventTouchUpInside];

  [_timer15 addTarget:self
                action:@selector(timerButtonTapped:)
      forControlEvents:UIControlEventTouchUpInside];

  [_timer10 addTarget:self
                action:@selector(timerButtonTapped:)
      forControlEvents:UIControlEventTouchUpInside];

  [_timer90 addTarget:self
                action:@selector(timerButtonTapped:)
      forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - TIMER

- (void)timerButtonTapped:(id)sender {

  UIButton *bt = (UIButton *)sender;
  // NSLog(@"Button %ld touched ", bt.tag);

  _timerObject = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%ld", bt.tag]];

  if (_timerObject != nil && (_timerObject.timerState == 2)) {

    // Has timer expired
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [_timerObject.startDate timeIntervalSince1970];

    if ((_timerObject.timerValue - tdf) <= 0) {
      [[SnowDataManager sharedInstance] removeSavedTimer:_timerObject];
      _timerObject = nil;
    } else {
      [[SnowNotificationManager sharedInstance]
          unscheduleNotificationWithTimerObject:_timerObject];
    }
  }

  if (_timerObject == nil) {
    [self createTimerWithValue:bt.tag];
  }

  [self startTimer];
}

- (void)setupCountdownView {

  UIFont *bf = [UIFont fontWithName:@"AvenirNextCondensed-UltraLight" size:92];

  CGRect labelFrame = CGRectInset(self.view.frame, 10, 50);

  // UIColor *buttonBorderColor = STM_buttonBorderColor;
  // UIColor *buttonTextColor = STM_buttonTextColor;
  UIColor *buttonTextColorSelected = STM_buttonTextColorSelected;

  _timerLabel = [[UILabel alloc] initWithFrame:labelFrame];
  _timerLabel.font = bf;
  _timerLabel.textColor = [[SnowAppearanceManager sharedInstance] currentTheme]
                              .primary; // buttonTextColor;
  _timerLabel.textAlignment = NSTextAlignmentCenter;

  _timerLabel.text = @"";

  _pauseTimerButton = [[UIButton alloc] init];
  _cancelTimerButton = [[UIButton alloc] init];

  [_pauseTimerButton addTarget:self
                        action:@selector(pauseResumeTimerToggle)
              forControlEvents:UIControlEventTouchUpInside];
  [_cancelTimerButton addTarget:self
                         action:@selector(cancelTimer)
               forControlEvents:UIControlEventTouchUpInside];

  [_pauseTimerButton setTitle:@"pause" forState:UIControlStateNormal];

  [_cancelTimerButton setTitle:@"cancel" forState:UIControlStateNormal];

  [_pauseTimerButton
      setTitleColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                        .primary
           forState:UIControlStateNormal];

  [_pauseTimerButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateHighlighted];

  [_cancelTimerButton
      setTitleColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                        .primary
           forState:UIControlStateNormal];
  [_cancelTimerButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateHighlighted];

  [_pauseTimerButton
      setBackgroundImage:
          [UIImage
              imageWithColor:
                  [[SnowAppearanceManager sharedInstance] currentTheme].primary]
                forState:UIControlStateHighlighted];

  [_cancelTimerButton
      setBackgroundImage:
          [UIImage
              imageWithColor:
                  [[SnowAppearanceManager sharedInstance] currentTheme].primary]
                forState:UIControlStateHighlighted];

  _pauseTimerButton.layer.borderWidth = 1;
  _pauseTimerButton.layer.borderColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary.CGColor;
  _cancelTimerButton.layer.borderWidth = 1;
  _cancelTimerButton.layer.borderColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary.CGColor;

  _isTimerPaused = NO;

  _controlArea = [[UIView alloc] init];

  [_timerCountDown addSubview:_timerLabel];

  [_controlArea addSubview:_cancelTimerButton];
  [_controlArea addSubview:_pauseTimerButton];

  [_timerCountDown addSubview:_controlArea];

  _timerComplete = [[UIButton alloc] init];
  [_timerComplete setTitle:@"close" forState:UIControlStateNormal];

  _timerComplete.layer.borderWidth = 1;
  _timerComplete.layer.borderColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary.CGColor;

  [_timerComplete
      setTitleColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                        .primary
           forState:UIControlStateNormal];

  [_timerComplete setTitleColor:buttonTextColorSelected
                       forState:UIControlStateHighlighted];

  [_timerComplete
      setBackgroundImage:
          [UIImage
              imageWithColor:
                  [[SnowAppearanceManager sharedInstance] currentTheme].primary]
                forState:UIControlStateHighlighted];

  [_timerComplete addTarget:self
                     action:@selector(closeCountDownView)
           forControlEvents:UIControlEventTouchUpInside];

  _timerComplete.alpha = 0;

  [_timerCountDown addSubview:_timerComplete];

  // button auto layout

  _pauseTimerButton.translatesAutoresizingMaskIntoConstraints = NO;
  _cancelTimerButton.translatesAutoresizingMaskIntoConstraints = NO;

  [_controlArea addConstraint:[NSLayoutConstraint
                                  constraintWithItem:_pauseTimerButton
                                           attribute:NSLayoutAttributeLeftMargin
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:_controlArea
                                           attribute:NSLayoutAttributeLeftMargin
                                          multiplier:1
                                            constant:10]];
  [_controlArea
      addConstraint:[NSLayoutConstraint constraintWithItem:_pauseTimerButton
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_controlArea
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:10]];

  [_pauseTimerButton
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_pauseTimerButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:140]];
  [_pauseTimerButton
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_pauseTimerButton
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:44]];

  [_controlArea
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_cancelTimerButton
                                 attribute:NSLayoutAttributeRightMargin
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_controlArea
                                 attribute:NSLayoutAttributeRightMargin
                                multiplier:1
                                  constant:-10]];

  [_controlArea
      addConstraint:[NSLayoutConstraint constraintWithItem:_cancelTimerButton
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:_controlArea
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1
                                                  constant:10]];

  [_cancelTimerButton
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_cancelTimerButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:140]];

  [_cancelTimerButton
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:_cancelTimerButton
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:44]];
}

- (void)createTimerWithValue:(NSInteger)tval {
  _timerObject = [[SnowTimer alloc] init];
  _timerObject.itemId = [[NSUUID UUID] UUIDString];
  _timerObject.timerState = 0;
  _timerObject.timerName = [NSString stringWithFormat:@"%ld", tval];
  _timerObject.timerValue = tval * 60;
  // save timer
  [[SnowDataManager sharedInstance] saveTimer:_timerObject];
}

- (void)startTimer {

  if (!_timerObject) {
    // NSLog(@"Could not fetch timer...");
    return;
  }

  if (_timerObject.timerState == 2) {

    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [_timerObject.startDate timeIntervalSince1970];
    _secondsLeft = _timerObject.timerValue - tdf;

    //_secondsLeft = //[self timeLeftFrom:_timerObject.timerValue - tdf];

  } else {
    _secondsLeft = _timerObject.timerValue;
  }

  _timerLabel.text = [self secondsToHMS:_secondsLeft];

  [self swapViews];

  if ((_timerObject.timerState == 2) || (_timerObject.timerState == 0)) {

    _timerEngine = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(showTimer)
                                                  userInfo:nil
                                                   repeats:YES];

    // _timerEngine.tolerance = 0.1;
    _timerObject.timerState = 2;

  } else {

    _isTimerPaused = YES;
    [_pauseTimerButton setTitle:@"resume" forState:UIControlStateNormal];
  }

  _controlArea.hidden = NO;
}

- (void)updateTimerState {
  _timerObject.timerValue = _secondsLeft;
  [[SnowDataManager sharedInstance] updatedTimer:_timerObject];
}

- (void)removeTimer {

  [[SnowDataManager sharedInstance] removeSavedTimer:_timerObject];
}

- (NSString *)secondsToHMS:(NSTimeInterval)sec {
  int hour, minutes, seconds;
  if (sec > 0) {
    hour = _secondsLeft / 3600;
    minutes = (_secondsLeft % 3600) / 60;
    seconds = (_secondsLeft % 3600) % 60;

    if (hour > 0) {
      return
          [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minutes, seconds];
    } else {
      return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }

  } else {
    return [NSString stringWithFormat:@"00:00:00"];
  }
}

- (NSTimeInterval)timeLeftFrom:(NSTimeInterval)sec {
  NSTimeInterval now = [[NSDate date] timeIntervalSince1970];

  NSTimeInterval timeLeft = sec - now;

  if (timeLeft > 0) {
    return timeLeft;
  }

  return 0;
}

- (void)showTimer {

  if (_secondsLeft > 0) {
    _timerLabel.text = [self secondsToHMS:_secondsLeft];
    --_secondsLeft;
    _pauseTimerButton.enabled = YES;
  } else {
    _pauseTimerButton.enabled = NO;
    [_timerEngine invalidate];
    _timerObject.timerState = 0;
    _isTimerPaused = NO;
    _timerLabel.text = [NSString stringWithFormat:@"Done!", nil];
    [self removeTimer];
    // NSLog(@"Time is up");

    /**
    [self performSelector:@selector(playAlert)
               withObject:nil
               afterDelay:2];
    **/

    _controlArea.hidden = YES;

    [self playAlert];

    [UIView animateWithDuration:0.5
        animations:^{
          _timerComplete.alpha = 1;
        }
        completion:^(BOOL finished){
            // NSLog(@"COMPLETED ....");
        }];
  }
}

- (void)pauseResumeTimerToggle {

  _isTimerPaused = !_isTimerPaused;

  if (_isTimerPaused) {
    [_timerEngine invalidate];
    [_pauseTimerButton setTitle:@"resume" forState:UIControlStateNormal];
    _timerObject.timerState = 1;
  } else {
    _timerObject.timerState = 2;
    [_pauseTimerButton setTitle:@"pause" forState:UIControlStateNormal];
    _timerEngine = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(showTimer)
                                                  userInfo:nil
                                                   repeats:YES];

    //_timerEngine.tolerance = 0.1;
  }
}

- (void)cancelTimer {
  // NSLog(@"Cancelling timer....");
  [_timerEngine invalidate];
  _isTimerPaused = NO;
  _timerLabel.text = @"";
  _timerObject.timerState = 0;

  [[SnowDataManager sharedInstance] removeSavedTimer:_timerObject];

  [self swapViews];
}

- (void)closeCountDownView {

  if ([_aPlayer isPlaying]) {
    [_aPlayer stop];
  }

  _timerComplete.alpha = 0;
  [self swapViews];
}

- (void)playAlert {

  NSError *audioErr;

  NSString *defaultSoundFileNameWithExtension =
      [[SnowAppearanceManager sharedInstance] currentAlertTone].soundName;

  NSString *defaultSoundFileNameExtension =
      [[defaultSoundFileNameWithExtension componentsSeparatedByString:@"."]
          objectAtIndex:1];
  NSString *defaultSoundFileName =
      [[defaultSoundFileNameWithExtension componentsSeparatedByString:@"."]
          objectAtIndex:0];

  //[defaultSoundFileName ];

  NSString *alertSoundFilePath =
      [[NSBundle mainBundle] pathForResource:defaultSoundFileName
                                      ofType:defaultSoundFileNameExtension];

  /**
    [[NSBundle mainBundle] pathForResource:@"railroad_crossing"
                                    ofType:@"wav"];
   **/

  if (!alertSoundFilePath) {
    // NSLog(@"Could not find sound file ");
  }

  NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:alertSoundFilePath];

  _aPlayer =
      [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&audioErr];

  _aPlayer.delegate = self;

  [_aPlayer prepareToPlay];

  _aPlayer.numberOfLoops = 1; // infinite

  [_aPlayer play];
}

#pragma mark - timer utility

- (void)showActiveTimerIndicators {

  int noteListeners = 0;

  if (_backgroundModeOn) {
    [showActiveTimerIndicators_timer invalidate];
    showActiveTimerIndicators_timer = nil;
    return;
  }

  // Fetch for active timers

  SnowTimer *tm5 = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%d", 5]];

  if (tm5.timerState == 2) {
    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm5.startDate timeIntervalSince1970];
    _secondsLeft5 = tm5.timerValue - tdf;

    if (_secondsLeft5 > 0) {
      [_timer5 listen:YES];
      ++noteListeners;
    } else {
      [_timer5 listen:NO];
    }

  } else {
    [_timer5 listen:NO];
  }

  SnowTimer *tm10 = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%d", 10]];

  if (tm10.timerState == 2) {
    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm10.startDate timeIntervalSince1970];
    _secondsLeft10 = tm10.timerValue - tdf;

    if (_secondsLeft10 > 0) {
      [_timer10 listen:YES];
      ++noteListeners;
    } else {
      [_timer10 listen:NO];
    }

  } else {
    [_timer10 listen:NO];
  }

  SnowTimer *tm15 = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%d", 15]];

  if (tm15.timerState == 2) {
    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm15.startDate timeIntervalSince1970];
    _secondsLeft15 = tm15.timerValue - tdf;

    if (_secondsLeft15 > 0) {
      [_timer15 listen:YES];
      ++noteListeners;
    } else {
      [_timer15 listen:NO];
    }

  } else {
    [_timer15 listen:NO];
  }

  SnowTimer *tm25 = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%d", 25]];

  if (tm25.timerState == 2) {
    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm25.startDate timeIntervalSince1970];
    _secondsLeft25 = tm25.timerValue - tdf;

    if (_secondsLeft25 > 0) {
      [_timer25 listen:YES];
      ++noteListeners;
    } else {
      [_timer25 listen:NO];
    }

  } else {
    [_timer25 listen:NO];
  }

  SnowTimer *tm45 = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%d", 45]];

  if (tm45.timerState == 2) {
    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm45.startDate timeIntervalSince1970];
    _secondsLeft45 = tm45.timerValue - tdf;

    if (_secondsLeft45 > 0) {
      [_timer45 listen:YES];
      ++noteListeners;
    } else {
      [_timer45 listen:NO];
    }

  } else {
    [_timer45 listen:NO];
  }

  SnowTimer *tm90 = [[SnowDataManager sharedInstance]
      fetchSavedTimerForKey:[NSString stringWithFormat:@"%d", 90]];

  if (tm90.timerState == 2) {
    // Adjust timer -- subst current time - creation time
    NSTimeInterval tdf = [[NSDate date] timeIntervalSince1970] -
                         [tm90.startDate timeIntervalSince1970];
    _secondsLeft90 = tm90.timerValue - tdf;

    if (_secondsLeft90 > 0) {
      [_timer90 listen:YES];
      ++noteListeners;
    } else {
      [_timer90 listen:NO];
    }

  } else {
    [_timer90 listen:NO];
  }

  // Send notifs to available listeners if any
  if (noteListeners > 0) {
    [self sendActiveTimerNotification];
  }
}

/*
- (void)flashButton:(UIButton *)bt {

  return;

  UIColor *buttonTextColor = STM_buttonBorderColor;

  [bt setBackgroundImage:[UIImage imageWithColor:buttonTextColor]
                forState:UIControlStateNormal];
}
*/

- (void)disableAllActiveTimers {

  [showActiveTimerIndicators_timer invalidate];
  showActiveTimerIndicators_timer = nil;
  [_timerEngine invalidate];
  _timerEngine = nil;
}

- (void)activateActiveTimersIndicators {

  showActiveTimerIndicators_timer = [NSTimer
      scheduledTimerWithTimeInterval:3
                              target:self
                            selector:@selector(showActiveTimerIndicators)
                            userInfo:nil
                             repeats:YES];
}

#pragma mark - utility

- (void)close:(id)sender {

  if ([_aPlayer isPlaying]) {
    [_aPlayer stop];
  }

  [self disableAllActiveTimers];
  //[showActiveTimerIndicators_timer invalidate];

  if (_timerObject && (_timerObject.timerState > 0)) {
    [self updateTimerState];
  }

  [self.presentingViewController dismissViewControllerAnimated:
                                     YES completion:^{
    [[SnowNotificationManager sharedInstance]
        scheduleNotificationWithTimerObject:_timerObject];
  }];
}

- (void)swapViews {
  UIView *topView, *bottomView;

  topView = [[self.view subviews] objectAtIndex:0];
  bottomView = [[self.view subviews] objectAtIndex:1];

  if (topView.tag == 2) {
    _countDownViewIsOn = YES; // future state
    //_backgroundModeOn = YES;
    [self disableAllActiveTimers];

  } else {
    _countDownViewIsOn = NO; // future state

    if (_backgroundModeOn == NO) {
      [self activateActiveTimersIndicators];
    }
  }

  [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
  topView.hidden = NO;
  bottomView.hidden = YES;
}

- (void)sendActiveTimerNotification {
  NSNotification *myNotification =
      [NSNotification notificationWithName:SnowActiveTimersPresent object:nil];

  [[NSNotificationCenter defaultCenter] postNotification:myNotification];
}

#pragma mark - VC Utility

- (void)updateAnalyticsWithScreen:(NSString *)screen {
  id tracker = [[GAI sharedInstance] defaultTracker];
  if (tracker && screen) {
    // [tracker set:kGAIScreenName value:screen];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                         set:screen
                      forKey:kGAIScreenName] build]];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self updateAnalyticsWithScreen:@"Quick Timer Screen"];

  NSDictionary *titleAttributes = @{
    NSFontAttributeName :
        [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
    NSForegroundColorAttributeName :
        [[SnowAppearanceManager sharedInstance] currentTheme].primary
  };

  self.navigationController.navigationBar.titleTextAttributes = titleAttributes;

  self.title = @"Timer";

  // Let app delegate know that we are the top parentless VC

  AppDelegate *app =
      (AppDelegate *)[[UIApplication sharedApplication] delegate];
  app.topVC = self;

  // self.title = @"Timer";
  // Do any additional setup after loading the view.

  UIImage *closeBt = [UIImage
      getTintedImage:[UIImage imageNamed:@"snow_menu_close"]
           withColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                         .primary];

  UIBarButtonItem *menuCloseButton =
      [[UIBarButtonItem alloc] initWithImage:closeBt
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(close:)];

  self.navigationItem.leftBarButtonItem = menuCloseButton;

  /*

self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
    initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                         target:self
                         action:@selector(close:)];

   */

  [self.navigationController.navigationBar
      setTintColor:[[SnowAppearanceManager sharedInstance] currentTheme]
                       .primary];

  /**

     UIColor *navBarBC =
  [[SnowAppearanceManager sharedInstance] currentTheme].primary;

self.view.backgroundColor =
    [[SnowAppearanceManager sharedInstance] currentTheme].primary;

   self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  UIImage *navBarBI = [UIImage imageWithColor:navBarBC];

  UIColor *navBarTintC =
  [[SnowAppearanceManager sharedInstance] currentTheme].secondary;



  [self.navigationController.navigationBar setTintColor:navBarTintC];

*/
  [self.navigationController.navigationBar
      setBackgroundImage:[UIImage new]
           forBarMetrics:UIBarMetricsDefault];
  [self.navigationController.navigationBar setShadowImage:[UIImage new]];

  [self setup];
  [self setupTimerButtons];
  [self setupCountdownView];

  _timerCountDown.hidden = YES;

  [self activateActiveTimersIndicators];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  // NSLog(@"CALLED %s", __func__);

  /**
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(appHasGoneInBackground:)
             name:UIApplicationDidEnterBackgroundNotification
           object:nil];
  **/

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(appHasGoneInBackground:)
             name:UIApplicationWillResignActiveNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(appHasGoneInBackground:)
             name:UIApplicationWillTerminateNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(appisBackIntoForeground:)
             name:UIApplicationWillEnterForegroundNotification
           object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(appisBackIntoForeground:)
             name:UIApplicationDidBecomeActiveNotification
           object:nil];

  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //                                             selector:@selector(appHasGoneInBackground:)
  //                                                 name:UIApplicationDidBecomeActiveNotification
  //                                               object:nil];
  //
  //    [[NSNotificationCenter defaultCenter] addObserver:self
  //                                             selector:@selector(appHasGoneInBackground:)
  //                                                 name:UIApplicationWillEnterForegroundNotification
  //                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  // NSLog(@"CALLED %s", __func__);

  [self disableAllActiveTimers];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
  // NSLog(@"========================== VC  dealloc called...");
}

- (void)appHasGoneInBackground:(NSNotification *)note {
  // NSLog(@"Received notif %@", note.name);
  _backgroundModeOn = YES;
  [self disableAllActiveTimers];

  if ([_aPlayer isPlaying]) {
    [_aPlayer stop];
  }

  if (_timerObject && (_timerObject.timerState > 0)) {
    [self updateTimerState];

    [[SnowNotificationManager sharedInstance]
        scheduleNotificationWithTimerObject:_timerObject];
  }

  @synchronized(self) {
    if (_countDownViewIsOn) {
      [self swapViews];
    }
  }
}

- (void)appisBackIntoForeground:(NSNotification *)note {
  _backgroundModeOn = NO;

  [self disableAllActiveTimers]; // We need this to be absolutely sure that all
                                 // timers are gone
  [self activateActiveTimersIndicators];
}

- (void)viewDidLayoutSubviews {

  // CGRect timerSettingsRect = CGRectInset(self.view.frame, 5, 100);

  CGRect timerRect25 = CGRectMake(0, 0, 100, 200);
  CGRect timerRect45 = CGRectMake(101, 0, 100, 140);
  CGRect timerRect5 = CGRectMake(201, 0, 100, 200);

  CGRect timerRect10 = CGRectMake(0, 200, 100, 200);
  CGRect timerRect15 = CGRectMake(101, 140, 100, 140);
  CGRect timerRect90 = CGRectMake(201, 200, 100, 140);

  CGRect buttonContainerFrame = CGRectMake(0, 0, 300, 401);

  _timerSettings.frame = self.view.bounds;
  _timerCountDown.frame = self.view.bounds; // timerSettingsRect;

  _buttonContainer.frame = buttonContainerFrame;

  _buttonContainer.center =
      CGPointMake(_timerSettings.center.x,
                  _timerSettings.center.y + 44); //_timerSettings.center;

  _timer25.frame = timerRect25;
  _timer45.frame = timerRect45;
  _timer5.frame = timerRect5;
  _timer10.frame = timerRect10;
  _timer15.frame = timerRect15;
  _timer90.frame = timerRect90;

  CGRect labelFrame = _timerCountDown.frame;
  _timerLabel.frame = labelFrame;

  CGRect bottomRect = CGRectMake(0, _timerCountDown.bounds.size.height - 80,
                                 _timerCountDown.bounds.size.width, 80);

  CGRect timerDoneButtonRect =
      CGRectMake(0, _timerCountDown.bounds.size.height - 100,
                 _timerCountDown.bounds.size.width - 100, 50);

  _controlArea.frame = bottomRect;

  _pauseTimerButton.frame = CGRectMake(50, 20, 100, 40);
  _cancelTimerButton.frame = CGRectMake(160, 20, 100, 40);

  _timerComplete.frame = timerDoneButtonRect;
  _timerComplete.center =
      CGPointMake(self.view.center.x, _timerComplete.center.y);
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {

  // NSLog(@"Player ddi stop");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error {

  // NSLog(@"Player decoding error");
}

@end
