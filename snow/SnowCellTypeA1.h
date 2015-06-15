//
//  SnowCellTypeA1.h
//  snow
//
//  Created by samuel maura on 5/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowButtonTypeA2.h"
#import "UIImage+SnowImageUtils.h"

@interface SnowCellTypeA1 : UITableViewCell

@property(nonatomic, copy) NSString *buttonLabel;
@property(nonatomic, copy) NSString *buttonImage;

@property(nonatomic, strong) SnowButtonTypeA2 *menuButton;

- (void)setup;

@end
