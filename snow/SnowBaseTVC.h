//
//  SnowBaseTVC.h
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+SnowImageUtils.h"
#import "SnowAppearanceManager.h"

@interface SnowBaseTVC : UITableViewController

@property(nonatomic, strong) UILabel *emptyLabel;
@property(nonatomic, strong) UIImage *closeBt;

- (void)showEmptyTable:(UITableView *)table
          ForContainer:(UIView *)container
           WithMessage:(NSString *)msg
          AndTextColor:(UIColor *)textColor;

- (void)applyTheme;

- (void)showEmptyDataMessageIfNeeded:(NSInteger)sec_count
                             WithMsg:(NSString *)msg
                            AndLabel:(UILabel *)msgLabel;

- (void)showAlertWithTitle:(NSString *)title AndMessage:(NSString *)msg;

@end
