//
//  SnowCardA.m
//  snow
//
//  Created by samuel maura on 4/23/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowCardA.h"
#import "SnowAppearanceManager.h"

@interface SnowCardA () {
  CGPoint _originalCenter;
  CGPoint _origin;
  BOOL _deleteOnDragRelease;
  BOOL _markCompleteOnDragRelease;
  UILabel *_done, *_delete;
  UIView *_sub;

  // Cell Separator
  CALayer *_containerLayer;

  // Cell panning state tracking
  BOOL isFullyOpen, isClose, isPanningLeft, _newSession, _reachedLimit;
  CGPoint _lastTranslation;
  CGPoint _startPos;
  CGRect _restPosForContainer;

  UITapGestureRecognizer *_tap;

  UIButton *_materialDelete;
  UIButton *_materialDone;
}

@end

@implementation SnowCardA

const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 80.0f;

- (void)awakeFromNib {
  // Initialization code

  // self.userInteractionEnabled = NO;
  //_dataContainerView.userInteractionEnabled = YES;

  self.selectionStyle = UITableViewCellSelectionStyleNone;

  self.taskTitle.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].primaryLabel;

  self.dueDate.textColor = self.listName.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].secondaryLabel;

  // rounded corners

  // self.dataContainerView.layer.masksToBounds = YES;
  // self.dataContainerView.layer.borderWidth = 1.0;
  // self.dataContainerView.layer.cornerRadius = 8.0;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateAppearance:)
                                               name:@"SnowThemeUpdate"
                                             object:nil];

  // fonts

  self.taskTitle.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20];

  //[UIFont fontWithName:@"Helvetica" size:16];
  self.dueDate.font =
      [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14];

  self.listName.font =
      [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14];

  _containerLayer = [CALayer layer];
  _containerLayer.backgroundColor =
      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;

  _containerLayer.frame =
      CGRectMake(_dataContainerView.frame.origin.x,
                 _dataContainerView.frame.size.height - 50.0,
                 _dataContainerView.frame.size.width, 1.0);

  [_dataContainerView.layer addSublayer:_containerLayer];

  // self.dataContainerView.layer

  // Gesture

  UIGestureRecognizer *recognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(ManagePan:)];
  recognizer.delegate = self;
  [_dataContainerView addGestureRecognizer:recognizer];

  // recognizer.cancelsTouchesInView = NO;

  // self.backgroundColor = [UIColor lightGrayColor];

  //[self createActionLabels];
  [self createSub];

  [self createAndAddButtons];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)layoutSubviews {
  [super layoutSubviews];

  ////NSLog(@"Layout subview called =======");

  CGRect cframe =
      CGRectMake(self.bounds.origin.x + 9, self.bounds.origin.y,
                 self.bounds.size.width - 18, self.bounds.size.height);

  //_sub.frame = _dataContainerView.frame;

  // //NSLog(@"CONTAINER FRAME : %@ ", _dataContainerView);

  _sub.frame = cframe;

  // layer - cell separator

  _containerLayer.frame =
      CGRectMake(_dataContainerView.frame.origin.x,
                 self.bounds.size.height - 1.0, self.bounds.size.width, 1.0);
  [_dataContainerView.layer addSublayer:_containerLayer];

  _restPosForContainer = _dataContainerView.frame;

  _materialDone.frame = CGRectMake(_sub.bounds.size.width - 50, 25, 25, 25);

  _materialDelete.frame = CGRectMake(_sub.bounds.size.width - 125, 25, 25, 25);
}

- (void)updateAppearance:(NSNotification *)note {
  self.taskTitle.textColor = self.dueDate.textColor = self.listName.textColor =
      [[SnowAppearanceManager sharedInstance] currentTheme].textColor;
}

#pragma mark - setup

- (void)createActionLabels {
  UILabel *done = [[UILabel alloc] initWithFrame:CGRectNull];
  UILabel *delete = [[UILabel alloc] initWithFrame:CGRectNull];

  done.font = [UIFont boldSystemFontOfSize:14.0];
  done.backgroundColor = [UIColor greenColor];
  done.textColor = [UIColor whiteColor];
  done.textAlignment = NSTextAlignmentCenter;
  done.text = @"DONE";
  // done.layer.borderWidth = 1.0;
  // done.layer.borderColor = [UIColor orangeColor].CGColor;

  delete.font = [UIFont boldSystemFontOfSize:14.0];
  delete.backgroundColor = [UIColor redColor];
  delete.textColor = [UIColor whiteColor];
  delete.textAlignment = NSTextAlignmentCenter;
  delete.text = @"DELETE";

  [self.dataContainerView addSubview:done];
  [self.dataContainerView addSubview:delete];

  _done = done;
  _delete = delete;
}

- (void)createSub {
  _sub = [[UIView alloc] init];
  _sub.backgroundColor = [UIColor orangeColor];

  CGRect cframe =
      CGRectMake(self.bounds.origin.x + 10, self.bounds.origin.y,
                 self.bounds.size.width - 20, self.bounds.size.height);

  _sub.frame = cframe;

  [self addSubview:_sub];
  [self sendSubviewToBack:_sub];
}

- (void)createAndAddButtons {
  UIImage *materialDelete = [UIImage imageNamed:@"material_delete"];
  UIImage *materialDone = [UIImage imageNamed:@"material_done"];

  _materialDelete = [[UIButton alloc] init];
  [_materialDelete setImage:materialDelete forState:UIControlStateNormal];
  _materialDone = [[UIButton alloc] init];
  [_materialDone setImage:materialDone forState:UIControlStateNormal];

  _materialDelete.backgroundColor = [UIColor clearColor];

  [_sub addSubview:_materialDelete];
  [_sub addSubview:_materialDone];

  [_materialDelete addTarget:self
                      action:@selector(deleteTapped:)
            forControlEvents:UIControlEventTouchUpInside];
  [_materialDone addTarget:self
                    action:@selector(doneTapped:)
          forControlEvents:UIControlEventTouchUpInside];

  //[self sendSubviewToBack:_sub];
}

- (void)deleteTapped:(id)sender {
  ////////NSLog(@"DELETE TAPPED");
  self.deleteTask();
}

- (void)doneTapped:(id)sender {
  ////NSLog(@"DONE TAPPED");
  self.completeTask();
}

#pragma mark - gesture delegate implementation

- (BOOL)gestureRecognizerShouldBegin:
    (UIPanGestureRecognizer *)gestureRecognizer {
  if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
    return NO;
  }

  CGPoint translation =
      [gestureRecognizer translationInView:[_dataContainerView superview]];
  // Check for horizontal gesture

  if (fabs(translation.x) > fabs(translation.y)) {
    return YES;
  }

  return NO;
}

/**
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  ////NSLog(@"TOUCH BEGAN");

  //[_sub touchesBegan:touches withEvent:event];
}
**/

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  ////NSLog(@"hIT TEST CALLED ...");

  if (_reachedLimit == YES) {

    CGPoint deletePoint = [_materialDelete convertPoint:point fromView:self];
    CGPoint donePoint = [_materialDone convertPoint:point fromView:self];

    if ([_materialDelete pointInside:deletePoint withEvent:event]) {
      ////NSLog(@"Point on delete");
      return _materialDelete;
    } else if ([_materialDone pointInside:donePoint withEvent:event]) {
      ////NSLog(@"Point on done");
      return _materialDone;
    }
  }
  // else {
  ////NSLog(@"Hit container..");
  // return [_dataContainerView hitTest:point withEvent:event];
  // }

  return [super hitTest:point withEvent:event];
}

- (void)ManageTapWhileOpen:(UITapGestureRecognizer *)pan {
  ////NSLog(@"RECEIVED TAP #######################\n");

  [UIView animateWithDuration:0.2
      animations:^{
        _dataContainerView.frame =
            CGRectMake(8.0, _origin.y, _dataContainerView.frame.size.width,
                       _dataContainerView.frame.size.height);

      }
      completion:^(BOOL finished) {
        [_dataContainerView removeGestureRecognizer:_tap];
        _tap = nil;

      }];
}

- (void)ManagePan:(UIPanGestureRecognizer *)pan {
  // //NSLog(@"CANCEL TOUCH IN VIEW %d", _dataContainerView.);
  switch (pan.state) {
  case UIGestureRecognizerStateBegan: {
    if (_tap == nil) {
      _tap = [[UITapGestureRecognizer alloc]
          initWithTarget:self
                  action:@selector(ManageTapWhileOpen:)];

      [_dataContainerView addGestureRecognizer:_tap];
    }

    _originalCenter = _dataContainerView.center;
    _origin = _dataContainerView.frame.origin;
    _lastTranslation = [pan translationInView:self];
    _startPos = _lastTranslation;
    _newSession = YES;
  }

  break;

  case UIGestureRecognizerStateChanged: {
    // NSLog(@"NEW SESSION = %d", _newSession);

    CGPoint prevPos = _lastTranslation;

    // NSLog(@"PREV X %lf Y %lf", prevPos.x, prevPos.y);

    _lastTranslation = [pan translationInView:self];

    // NSLog(@"LAST  X %lf Y %lf", _lastTranslation.x, _lastTranslation.y);

    // direction
    if (prevPos.x > _lastTranslation.x) {
      isPanningLeft = YES;
      // NSLog(@"Moving LEFT ++++++++++");
    } else {
      // NSLog(@"Moving RIGHT ++++++++++");
      isPanningLeft = NO;
    }

    /**
      if ((fabs(_lastTranslation.x) >= 150)) {
        //NSLog(@" STOPPPPPING");

        // RESET POSITION IF WE GO OVER

        if (fabs(_dataContainerView.frame.origin.x) != 150) {
          [UIView animateWithDuration:0.2
              animations:^{
                if (!isPanningLeft) {
                  //NSLog(@" RESETTING RIGHT");
                  _dataContainerView.frame = CGRectMake(
                      150, _origin.y, _dataContainerView.frame.size.width,
                      _dataContainerView.frame.size.height);

                } else {
                  //NSLog(@" RESETTING LEFT");
                  _dataContainerView.frame = CGRectMake(
                      -150, _origin.y, _dataContainerView.frame.size.width,
                      _dataContainerView.frame.size.height);
                }

              }
              completion:^(BOOL finished){

              }];
        }

        _newSession = NO;
        return;
      }

    **/

    // NSLog(@"CONTAINER POS ^^^^  X %lf  ORIGINAL %lf \n ",
    //_dataContainerView.frame.origin.x, _restPosForContainer.origin.x);

    if ((isPanningLeft == YES) &&
        (fabs(_dataContainerView.frame.origin.x) >= 140)) {
      // NSLog(@"LIMIT REACHED \\\\\\\\\\\\\\ ");
      _reachedLimit = YES;
      return;
    } else {
      _reachedLimit = NO;
    }

    if ((!isPanningLeft) && (_dataContainerView.frame.origin.x >= 8.0)) {
      // NSLog(@"******* NOT UPDATING POS .......");
      return;
    }

    _dataContainerView.center =
        CGPointMake(_originalCenter.x + _lastTranslation.x, _originalCenter.y);

    // NSLog(@"UPDATING POS .......");

    _newSession = NO;

  } break;

  case UIGestureRecognizerStateEnded: {
    if (_reachedLimit == NO) {
      [UIView animateWithDuration:0.2
          animations:^{
            _dataContainerView.frame =
                CGRectMake(8.0, _origin.y, _dataContainerView.frame.size.width,
                           _dataContainerView.frame.size.height);

          }
          completion:^(BOOL finished) {
            [_dataContainerView removeGestureRecognizer:_tap];
            _tap = nil;

          }];
    } else {
      [UIView animateWithDuration:0.1
          animations:^{
            _dataContainerView.frame = CGRectMake(
                -150.0, _origin.y, _dataContainerView.frame.size.width,
                _dataContainerView.frame.size.height);

          }
          completion:^(BOOL finished){

          }];
    }

  }

  break;

  default:
    // NSLog(@"Default panning case");
    break;
  }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
  // 1
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    // if the gesture has just started, record the current centre location
    _originalCenter = _dataContainerView.center;
    _origin = _dataContainerView.frame.origin;
  }

  // 2
  else if (recognizer.state == UIGestureRecognizerStateChanged) {
    // translate the center
    CGPoint translation = [recognizer translationInView:_dataContainerView];

    _dataContainerView.center =
        CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
    // determine whether the item has been dragged far enough to initiate a

    // delete / complete
    _deleteOnDragRelease = _dataContainerView.frame.origin.x <=
                           -_dataContainerView.frame.size.width / 3;

    _markCompleteOnDragRelease = _dataContainerView.frame.origin.x >=
                                 _dataContainerView.frame.size.width / 3;

    /*
    float cueAlpha = fabs(_dataContainerView.frame.origin.x) /
                     (_dataContainerView.frame.size.width / 2);



    float mcue = fabs(_dataContainerView.frame.origin.x) /
                 (_dataContainerView.frame.size.width / 2);
    if (mcue > 0.95) {
      mcue = 0.95;
    }

    //NSLog(@"MCUE %lf", mcue);

    _delete.transform = CGAffineTransformMakeScale(mcue, mcue);
    _done.transform = CGAffineTransformMakeScale(mcue, mcue);

    //NSLog(@"cue alpha %lf ", cueAlpha);
  */
  }

  // 3
  else if (recognizer.state == UIGestureRecognizerStateEnded) {
    // the frame this cell would have had before being dragged
    CGRect originalFrame =
        CGRectMake(_origin.x, _origin.y, _dataContainerView.bounds.size.width,
                   _dataContainerView.bounds.size.height);

    if (_dataContainerView.frame.origin.x <= 0) {
      if (!_deleteOnDragRelease) {
        // //NSLog(@" ++++++++++++++++++ Will not delete  _deleteOnDragRelease
        // %d
        // ",
        //      _deleteOnDragRelease);

        // if the item is not being deleted, snap back to the original location
        [UIView animateWithDuration:0.5
                         animations:^{
                           _dataContainerView.frame = originalFrame;
                         }];

      } else {
        // NSLog(@" ++++++++++++++++++ Will delete  _deleteOnDragRelease %d ",
        //_deleteOnDragRelease);

        // self.deleteTask();

        [UIView animateWithDuration:0.5
                         animations:^{
                           _dataContainerView.frame = originalFrame;
                         }];
      }

    } else {
      if (!_markCompleteOnDragRelease) {
        [UIView animateWithDuration:0.5
                         animations:^{
                           _dataContainerView.frame = originalFrame;
                         }];

      } else {
        // NSLog(@"COMPLETE TASK .....");
        // self.completeTask();

        [UIView animateWithDuration:0.5
                         animations:^{
                           _dataContainerView.frame = originalFrame;
                         }];
      }
    }
  }
}

@end
