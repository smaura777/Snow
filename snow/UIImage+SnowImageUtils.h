//
//  UIImage+SnowImageUtils.h
//  snow
//
//  Created by samuel maura on 5/27/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SnowImageUtils)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)getTintedImage:(UIImage *)image withColor:(UIColor *)tintColor;

@end
