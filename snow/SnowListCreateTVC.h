//
//  SnowListCreateTVC.h
//  snow
//
//  Created by samuel maura on 3/28/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowAppearanceManager.h"
#import "SimpleTextViewCell.h"
#import "SnowSimpleTextFieldCell.h"

@interface SnowListCreateTVC : SnowBaseTVC <UITextFieldDelegate>

/*
- (IBAction)saveListAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

 */

@property(weak, nonatomic) UITextField *ListName;

//@property(weak, nonatomic) IBOutlet SimpleTextViewCell *textViewCell;

@property(nonatomic, copy) void (^saveList)(NSString *title);
@end
