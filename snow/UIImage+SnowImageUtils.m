//
//  UIImage+SnowImageUtils.m
//  snow
//
//  Created by samuel maura on 5/27/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "UIImage+SnowImageUtils.h"

@implementation UIImage (SnowImageUtils)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, color.CGColor);
  CGContextFillRect(context, (CGRect){.size = size});

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
  return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)getTintedImage:(UIImage *)image withColor:(UIColor *)tintColor {
  UIGraphicsBeginImageContextWithOptions(image.size, NO,
                                         [[UIScreen mainScreen] scale]);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextTranslateCTM(context, 0, image.size.height);
  CGContextScaleCTM(context, 1.0, -1.0);

  CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);

  // draw alpha-mask
  CGContextSetBlendMode(context, kCGBlendModeNormal);
  CGContextDrawImage(context, rect, image.CGImage);

  // draw tint color, preserving alpha values of original image
  CGContextSetBlendMode(context, kCGBlendModeSourceIn);
  [tintColor setFill];
  CGContextFillRect(context, rect);

  UIImage *coloredImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return coloredImage;
}

@end
