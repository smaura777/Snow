//
//  SnowSimpleTextFieldCell.h
//  snow
//
//  Created by samuel maura on 6/8/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowSimpleTextFieldCell : UITableViewCell
@property (nonatomic,strong) UITextField *textField;

- (void)setupWithPlaceHolder:(NSString *)placeholder
            PlaceHolderColor:(UIColor *)placeholderColor
                AndTextColor:(UIColor *)textColor;

@end
