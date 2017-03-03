//
//  WebViewController.h
//  ApprovalRating
//
//  Created by Louis Harris on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKNavigationDelegate>
@property (strong, nonatomic)WKWebView* webView;
@property (strong, nonatomic)NSString* articleURL;

@end
