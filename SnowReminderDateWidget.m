//
//  SnowReminderDateWidget.m
//  snow
//
//  Created by samuel maura on 4/3/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowReminderDateWidget.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@interface SnowReminderDateWidget ()

@end

@implementation SnowReminderDateWidget

- (void)viewDidLoad {
  [super viewDidLoad];

  [self updateAnalyticsWithScreen:@"Create Task Reminder Screen"];

  self.view.backgroundColor =
      [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1];
  //[UIColor blackColor];
  //[[SnowAppearanceManager sharedInstance] currentTheme].ternary;
  /*
_reminderDatePicker.tintColor =
    [[SnowAppearanceManager sharedInstance] currentTheme].primary;
  */

  //[[UIDatePicker appearance] setTintColor: [[SnowAppearanceManager
  // sharedInstance] currentTheme].primary;

  _reminderDatePicker.backgroundColor = [UIColor clearColor];
  //[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.77];

  // check for key value compliance

  @try {

    [_reminderDatePicker
        setValue:[[SnowAppearanceManager sharedInstance] currentTheme].primary
          forKey:@"textColor"];

  } @catch (NSException *exception) {
    // NSLog(@"CAUGHT %@", [exception name]);
  }

  // [_reminderLabel setValue: [UIFont fontWithName:@"AvenirNext-Medium"
  // size:22] forKey:@"font"];

  _reminderLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:22];

  _reminderLabel.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primary;

  // Do any additional setup after loading the view.
  if (_currentReminder) {
    [_reminderDatePicker setDate:_currentReminder animated:YES];
  }
}

- (void)updateAnalyticsWithScreen:(NSString *)screen {
  id tracker = [[GAI sharedInstance] defaultTracker];
  if (tracker && screen) {
    // [tracker set:kGAIScreenName value:screen];
    [tracker send:[[[GAIDictionaryBuilder createScreenView]
                         set:screen
                      forKey:kGAIScreenName] build]];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)reminderDatePickerChanged:(id)sender {
  UIDatePicker *dp = (UIDatePicker *)sender;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateStyle = NSDateFormatterShortStyle;
  formatter.timeStyle = NSDateFormatterShortStyle;

  _reminderLabel.text = [formatter stringFromDate:dp.date];

  self.reminderChanged(dp.date);
}
@end
