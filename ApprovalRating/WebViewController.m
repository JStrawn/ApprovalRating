//
//  WebViewController.m
//  ApprovalRating
//
//  Created by Louis Harris on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    WKWebViewConfiguration *theConfig = [[WKWebViewConfiguration alloc]init];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:screenBounds configuration:theConfig];
    webView.navigationDelegate = self;
    
    NSURL *website = [NSURL URLWithString: self.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:website];
    [webView loadRequest:urlRequest];
    [self.view addSubview:webView];
    
    // Do any additional setup after loading the view.
    
    //    [self configWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)configWebView
//{
//    WKWebViewConfiguration* theConfiguration = [[WKWebViewConfiguration alloc]init];
//    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:theConfiguration];
//    self.webView.navigationDelegate = self;
//}


//Miguel:I have no clue what 'mostPopularArticle' and 'secondMostPopularArticle' methods do. I'm commenting them out.//

//-(void)mostPopularArticle
//{
//    //if score is the greatest number
//    NSURL* currentURL = [NSURL URLWithString:self.articleURL];
//    NSURLRequest* nsRequest = [NSURLRequest requestWithURL:currentURL];
//    [self.webView loadRequest:nsRequest];
//    [self.view addSubview:self.webView];
//}
//
//-(void)secondMostPopularArticle
//{
//    //if score second highest or eqaul to greatest
//    NSURL* currentURL = [NSURL URLWithString:self.articleURL];
//
//    NSURLRequest* nsRequest = [NSURLRequest requestWithURL:currentURL];
//    [self.webView loadRequest:nsRequest];
//    [self.view addSubview:self.webView];
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
