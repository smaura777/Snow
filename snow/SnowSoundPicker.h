//
//  SnowSoundPicker.h
//  snow
//
//  Created by samuel maura on 6/10/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowBaseTVC.h"
#import "SnowDataManager.h"
#import "SnowAppearanceManager.h"
#import <AVFoundation/AVFoundation.h>

@interface SnowSoundPicker : SnowBaseTVC <AVAudioPlayerDelegate>
@property(nonatomic, strong) NSDictionary *soundList;
@property(nonatomic, strong) SnowSound *selectedSound;

@end
