//
//  NewsEntry.h
//  ApprovalRating
//
//  Created by Louis Harris on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface NewsEntry : UIViewController<WKNavigationDelegate>

//(might not be needed) @property (strong, nonatomic)NSString* newsTitle;
@property (retain, nonatomic)NSURL* newsArticleURL;
@property (retain, nonatomic)NSString* imageURL;
@property (strong, nonatomic)WKWebView* webView;
@property (strong, nonatomic)NSMutableDictionary* entries;


@end
