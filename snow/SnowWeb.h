//
//  SnowWeb.h
//  snow
//
//  Created by samuel maura on 6/16/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface SnowWeb : UIViewController <WKNavigationDelegate>
@property (nonatomic,copy) NSString *url;
@end
