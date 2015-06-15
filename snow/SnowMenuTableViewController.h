//
//  SnowMenuTableViewController.h
//  snow
//
//  Created by samuel maura on 3/31/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnowMenuTableViewController : UITableViewController

@property(nonatomic, copy) void (^appMenuSelected)(NSInteger tag);

@end
