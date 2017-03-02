//
//  NewsEntry.m
//  ApprovalRating
//
//  Created by Louis Harris on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "NewsEntry.h"

@interface NewsEntry()

@end

@implementation NewsEntry

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self configWebView];
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    //sort through dictionary entries get the hightest score from dictionary
    
    //take the second highest or another score that's equal
}

-(void)configWebView
{
    WKWebViewConfiguration* theConfiguration = [[WKWebViewConfiguration alloc]init];
    self.webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:theConfiguration];
    self.webView.navigationDelegate = self;
}

-(void)mostPopularArticle
{
    //if score is the greatest number
    NSURLRequest* nsRequest = [NSURLRequest requestWithURL:self.newsArticleURL];
    [self.webView loadRequest:nsRequest];
    [self.view addSubview:self.webView];
}

-(void)secondMostPopularArticle
{
    //if score second highest or eqaul to greatest
    NSURLRequest* nsRequest = [NSURLRequest requestWithURL:self.newsArticleURL];
    [self.webView loadRequest:nsRequest];
    [self.view addSubview:self.webView];
}

@end
