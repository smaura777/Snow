//
//  SnowReminderDateWidget.h
//  snow
//
//  Created by samuel maura on 4/3/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowAppearanceManager.h"

@interface SnowReminderDateWidget : UIViewController
@property(weak, nonatomic) IBOutlet UILabel *reminderLabel;
@property(weak, nonatomic) IBOutlet UIDatePicker *reminderDatePicker;
@property(nonatomic, copy) void (^reminderChanged)(NSDate *item);
@property(nonatomic, strong) NSDate *currentReminder;

- (IBAction)reminderDatePickerChanged:(id)sender;

@end
