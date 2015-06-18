//
//  SnowWeb.m
//  snow
//
//  Created by samuel maura on 6/16/15.
//  Copyright (c) 2015 samuel maura. All rights reserved.
//

#import "SnowWeb.h"
#import "SnowAppearanceManager.h"
#import "UIImage+SnowImageUtils.h"
#import "AppDelegate.h"

@interface SnowWeb ()

@end

@implementation SnowWeb {

  UIWebView *_kweb;
  NSURL *_link;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  //    AppDelegate *app =
  //    (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //    app.topVC = self;
  //
  //   UIImage * _closeBt = [UIImage
  //                getTintedImage:[UIImage imageNamed:@"snow_menu_close"]
  //                withColor:[[SnowAppearanceManager sharedInstance]
  //                currentTheme]
  //                .primary];
  //

  //    self.navigationItem.leftBarButtonItem =
  //    [[UIBarButtonItem alloc] initWithImage:_closeBt
  //                                     style:UIBarButtonItemStylePlain
  //                                    target:self
  //                                    action:@selector(close:)];

  // Do any additional setup after loading the view.

  if (_url) {
    _link = [NSURL URLWithString:_url];
    _kweb = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_kweb];
    _kweb.delegate = self;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  if (_kweb) {
    [_kweb loadRequest:[NSURLRequest requestWithURL:_link]];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)close:(id)sender {
  [self.presentingViewController dismissViewControllerAnimated:YES
                                                    completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma amrk - uiwebview delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  //NSLog(@"Loading failed");
}

/**
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation
*)navigation {
    //NSLog(@"Navigation succeeded");
}


- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation
*)navigation withError:(NSError *)error {
    //NSLog(@"Navigation failed");
}
**/

@end
