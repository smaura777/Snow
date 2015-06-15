//
//  SnowCustomTransition.h
//  snow
//
//  Created by samuel maura on 3/31/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowCustomTransition
    : NSObject <UIViewControllerAnimatedTransitioning>

@property(nonatomic, assign, getter=isAppearing) BOOL appearing;
@property(nonatomic, assign) NSTimeInterval duration;

@property(nonatomic, strong) UIView *transparentView;

@end
