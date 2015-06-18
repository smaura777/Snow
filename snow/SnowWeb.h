//
//  SnowWeb.h
//  snow
//
//  Created by samuel maura on 6/16/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface SnowWeb : UIViewController <UIWebViewDelegate>
@property (nonatomic,copy) NSString *url;
@end
