//
//  SnowTaskCreateTVC.h
//  snow
//
//  Created by samuel maura on 3/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowDataManager.h"
#import "SnowNotificationManager.h"
#import "SnowBaseTVC.h"

@interface SnowTaskCreateTVC : SnowBaseTVC <UITextViewDelegate>

@property(nonatomic, strong) SnowList *selectedList;
@property(nonatomic, strong) void (^saveTask)(SnowTask *item);
@property(nonatomic, strong) void (^updateTask)(SnowTask *item);
@property(nonatomic, assign, getter=isEditModeOn) BOOL editModeOn;
@property(nonatomic, strong) SnowTask *taskToEdit;

@property(nonatomic, strong) NSDate *reminderDate;
@property(nonatomic, assign) NSCalendarUnit repeatFrequency;
@property(nonatomic, strong) NSString *repeatFrequencyString;

@property(nonatomic, copy) NSString *taskTitle;
@property(nonatomic, copy) NSString *listTitle;

@property(nonatomic, strong) NSNumber *taskPriority;

// Changed status
@property BOOL dateHasChanged;
@property BOOL frequencyHasChanged;

- (IBAction)changeListAction:(id)sender;

- (IBAction)reminderTapped:(id)sender;

- (IBAction)reminderRepeatTapped:(id)sender;

- (void)populateVC;

- (IBAction)saveAction:(id)sender;

- (IBAction)cancelAction:(id)sender;

@end
