//
//  SnowButtonTypeA1.h
//  snow
//
//  Created by samuel maura on 5/27/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+SnowImageUtils.h"
#import "SnowAppearanceManager.h"

@interface SnowButtonTypeA1 : UIButton

- (void)listen:(BOOL)status;

- (void)customizeForType:(NSUInteger)type;

@end
