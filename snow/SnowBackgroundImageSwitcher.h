//
//  SnowBackgroundImageSwitcher.h
//  snow
//
//  Created by samuel maura on 4/29/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowAppearanceManager.h"
#import "SnowBackground.h"

@interface SnowBackgroundImageSwitcher : UITableViewController

@property(nonatomic, strong) NSArray *imageThemes;
@property(nonatomic, strong) SnowBackground *selectedBackground;

@end
