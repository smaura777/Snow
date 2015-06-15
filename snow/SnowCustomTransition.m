//
//  SnowCustomTransition.m
//  snow
//
//  Created by samuel maura on 3/31/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowCustomTransition.h"
#import "SnowAppearanceManager.h"

static CGFloat const kInitialScale = 0.01;

static CGFloat const kFinalScale = 0.95;

@implementation SnowCustomTransition

- (NSTimeInterval)transitionDuration:
    (id<UIViewControllerContextTransitioning>)transitionContext {
  return 0.20;
}

- (void)animateTransition:
    (id<UIViewControllerContextTransitioning>)transitionContext {
  UIView *containerView = [transitionContext containerView];
  NSTimeInterval duration = [self transitionDuration:transitionContext];

  UIViewController *fromVC; //= [transitionContext
  // viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *toVC; //= [transitionContext
  // viewControllerForKey:UITransitionContextToViewControllerKey];

  //  NSLog(@" FROM vc %@",
  //        [[transitionContext
  //            viewControllerForKey:
  //                UITransitionContextFromViewControllerKey] description]);
  //
  //  NSLog(
  //      @" FROM presenting VC %@",
  //      [[[[transitionContext
  //          viewControllerForKey:
  //              UITransitionContextFromViewControllerKey]
  //              childViewControllers] firstObject] description]);
  //
  //  NSLog(@" TO vc %@",
  //        [[transitionContext
  //            viewControllerForKey:
  //                UITransitionContextToViewControllerKey] description]);
  //
  //  NSLog(@" CONTAINER vc %@",
  //        [[[transitionContext containerView] subviews] description]);

  UIView *fromView;
  UIView *toView;

  if (_appearing == YES) {
    fromVC = [[[transitionContext
        viewControllerForKey:
            UITransitionContextFromViewControllerKey] childViewControllers] firstObject];

    toVC = [transitionContext
        viewControllerForKey:UITransitionContextToViewControllerKey];
  } else {
    fromVC = [transitionContext
        viewControllerForKey:UITransitionContextFromViewControllerKey];
    toVC = [[[transitionContext
        viewControllerForKey:
            UITransitionContextToViewControllerKey] childViewControllers] firstObject];
  }

  fromView = [fromVC view];
  toView = [toVC view];

  // Presenting
  if (self.appearing) {
    _transparentView =
        [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _transparentView.backgroundColor = [UIColor lightGrayColor];

    //  [[SnowAppearanceManager sharedInstance] currentThem].primary;

    _transparentView.alpha = 0.7;

    // [fromView addSubview:_transparentView];

    fromView.userInteractionEnabled = NO;

    // Round the corners
    toView.layer.cornerRadius = 5;
    toView.layer.masksToBounds = YES;

    toView.layer.shadowOpacity = 0.8;
    toView.layer.shadowOffset = CGSizeMake(10.0, 10.0);

    // Set initial scale to zero

      CGRect incomingViewFrame = fromView.frame;
       // CGRectInset(fromView.bounds, 20, fromView.bounds.size.height / 6);

    toView.frame = incomingViewFrame;
    //toView.alpha = 0;

    toView.transform = CGAffineTransformMakeScale(kInitialScale,kInitialScale);
      
    [containerView addSubview:_transparentView]; // Add transparent view

    [containerView addSubview:toView];

    // Scale up to 90%
    [UIView animateWithDuration:duration
        animations:^{
          
        toView.transform =
            CGAffineTransformMakeScale(kFinalScale, kFinalScale);
       
         // toView.alpha = 1.0;

           //fromView.alpha = 0.5;
        }
        completion:^(BOOL finished) {

          [transitionContext completeTransition:YES];

        }];
  }
  // Dismissing
  else {
    // Scale down to 0
    [UIView animateWithDuration:duration
        animations:^{
          
        fromView.transform =
            CGAffineTransformMakeScale(kInitialScale, kInitialScale);
        
          fromView.alpha = 0;

          // toView.alpha = 1.0;
        }
        completion:^(BOOL finished) {

          // NSLog(@" tOVIEW LAYERS %@ ", [[toView subviews] description]);

          [fromView removeFromSuperview];
          toView.userInteractionEnabled = YES;
          [transitionContext
              completeTransition:![transitionContext transitionWasCancelled]];
        }];
  }
}

@end
