//
//  SnowMainContainerVC.h
//  snow
//
//  Created by samuel maura on 3/31/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnowMenuTableViewController.h"
#import "SnowMenuTVCA1.h"
#import "SnowTableViewController.h"
#import "SnowListAllTVC.h"
#import "SnowTaskAllTVC.h"
#import "SnowSearchResultsTVC.h"
#import "SnowListManager.h"
#import "SnowAboutMaster.h"

@interface SnowMainContainerVC
    : UIViewController<UISearchControllerDelegate, UISearchResultsUpdating>

@property(nonatomic, strong) SnowMenuTVCA1 *mainMenu;
@property(nonatomic, strong) UINavigationController *mainMenuNav;

@property(nonatomic, strong) SnowTableViewController *home;
@property(nonatomic, strong) UIViewController *topVC;

@property(nonatomic, copy) NSString *topVCTitle;

@property(nonatomic, assign, getter=isMenuOpen) BOOL menuOpen;

@property(nonatomic, strong) SnowListManager *listManager;

- (void)toggleMenu:(id)sender;

@end
