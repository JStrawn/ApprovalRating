//
//  ViewController.m
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "ViewController.h"
#import "DAO.h"

@interface ViewController ()

@property double postiveScore;
@property double negativeScore;
@property double neutralScore;
@property double totalScore;

@property double postivePercentage;
@property double negativePercentage;
@property double neutralPercentage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///////////////////////////////////////////////////////////////////////////
    //
    // Nav Bar & UI Setup
    //
    ///////////////////////////////////////////////////////////////////////////
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aprvd_logo.png"]] ;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 48, 18);
    self.containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
    self.containerView.layer.cornerRadius = 5;
    self.navigationItem.titleView = imageView;
    
    // left nav - info button
    UIImageView *infoButtonView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"info_icon.png"]];
    infoButtonView.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithCustomView:infoButtonView];

    
    self.navigationItem.leftBarButtonItem= infoButton;
    
    // submit button
    self.submitButton.backgroundColor = UIColorFromRGB(0x6da7d3);
    self.submitButton.layer.cornerRadius = 5;
    
    // Gradient view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)UIColorFromRGB(0xae4ea7).CGColor, (id)UIColorFromRGB(0x7abff2).CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    ///////////////////////////////////////////////////////////////////////////
    //
    // DAO Init & Testing
    //
    ///////////////////////////////////////////////////////////////////////////
    self.dao = [[DAO alloc]init];
    
    // testing
    [self.dao getPositiveSentimentValues];
    [self.dao getNegativeSentimentValues];
    [self.dao getNeutralSentimentValues];
    [self.dao getNewsStories];
    
    NSLog(@"pos %d, neg %d, neu %d", self.dao.positiveSentimentValue, self.dao.negativeSentimentValue, self.dao.neutralSentimentValue);

}

-(void)apiCallComplete:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"Address Found"]) {
        NSLog(@"pos %d, neg %d, neu %d", self.dao.positiveSentimentValue, self.dao.negativeSentimentValue, self.dao.neutralSentimentValue);
    }
}


- (IBAction)submitButtonPrsd:(id)sender {
}

- (IBAction)resultLauncher:(id)sender {
    ResultController *resultController = [[ResultController alloc] init];
    [self presentViewController:resultController animated:YES completion:nil];
}

@end
