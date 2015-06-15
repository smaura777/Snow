//
//  SnowSearchTVC.h
//  snow
//
//  Created by samuel maura on 5/20/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowSearchResultsTVC.h"
#import "SnowListManager.h"
#import "SnowTaskDetailsTVC.h"
#import "SnowBaseTVC.h"

@interface SnowSearchTVC
    : SnowBaseTVC <UISearchControllerDelegate, UISearchResultsUpdating,
                   UISearchBarDelegate, SnowTaskDetailsTVCDelegate,
                   SnowSearchResultsTVCDelegate>

@property(nonatomic, copy) void (^menuTapped)(void);

@end
