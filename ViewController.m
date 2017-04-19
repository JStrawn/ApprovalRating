//
//  ViewController.m
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "ViewController.h"
//#import "DAO.h"

@interface ViewController () <UITextFieldDelegate> {
    CGRect textFrame;
    
    bool posCompletion;
    bool neuCompletion;
    bool negCompletion;
    bool newsDownload;
}

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
    
    self.nameInputTextField.delegate = self;
    
#pragma mark PLACEHOLDER, comment out for real searching
    //self.nameInputTextField.text = @"Bernie Sanders";
    // self.nameInputTextField.text = self.sharedManager.userSearchString;
    
    self.navigationItem.leftBarButtonItem= infoButton;
    
    // submit button
    self.submitButton.backgroundColor = UIColorFromRGB(0x6da7d3);
    self.submitButton.layer.cornerRadius = 5;
    
    self.sharedManager = [DAO sharedManager];
    
    self.sharedManager.userSearchString = [[NSMutableString alloc]init];
    self.sharedManager.noSpacesUserSearchString = [self.sharedManager.userSearchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //self.sharedManager.fixedUserSearchString = [self.noSpacesUserSearchString stringByAppendingString:@"%22"];
    
    
    // Gradient background view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = @[(id)UIColorFromRGB(0xae4ea7).CGColor, (id)UIColorFromRGB(0x7abff2).CGColor];
    
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    ///////////////////////////////////////////////////////////////////////////
    //
    // DAO Init, Testing, & Keyboard
    //
    ///////////////////////////////////////////////////////////////////////////
    
    //register for download finished notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Positive Finished"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Negative Finished"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Neutral Finished"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"News Finished"
                                               object:nil];
    
    //register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.nameInputTextField.translatesAutoresizingMaskIntoConstraints = YES;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.firstTimeCalled = YES;
    //[self triggerLoadingView:self];
    posCompletion = NO;
    negCompletion = NO;
    neuCompletion = NO;
    newsDownload = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receivedNotification:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"Positive Finished"]) {
        posCompletion = YES;
    } if ([[notification name] isEqualToString:@"Negative Finished"]) {
        negCompletion = YES;
    } if ([[notification name] isEqualToString:@"Neutral Finished"]) {
        neuCompletion = YES;
    } if ([[notification name] isEqualToString:@"News Finished"])
        newsDownload = YES;
    
    [self checkDLCompletion];
}

-(void)checkDLCompletion {
    if (negCompletion && neuCompletion && posCompletion && newsDownload) {
        ResultController *resultController = [[ResultController alloc] init];
        [self presentViewController:resultController animated:YES completion:nil];
        //[self resultLauncher];
        // hide loading view if it's showing
        if (self.loadingView.isHidden == false) {
            [self triggerLoadingView:self];
        }
    }
}

- (IBAction)submitButtonPrsd:(id)sender {
    
    self.sharedManager.userSearchString = self.nameInputTextField.text;
    self.sharedManager.noSpacesUserSearchString = [self.sharedManager.userSearchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    self.sharedManager.fixedUserSearchString = [self.sharedManager.noSpacesUserSearchString stringByAppendingString:@"%20"];
    
    [self.sharedManager getPositiveSentimentValues];
    [self.sharedManager getNegativeSentimentValues];
    [self.sharedManager getNeutralSentimentValues];
    [self.sharedManager getNewsStories];
    
    [self triggerLoadingView:self];
}

////This is to test the push to the resultViewController//
//- (void)resultLauncher {
//    ResultController *resultController = [[ResultController alloc] init];
//    // resultController.posScoreLabel.text = [NSString stringWithFormat:@"%d",self.dao.positiveSentimentValue];
//    [self presentViewController:resultController animated:YES completion:nil];
//}
//This is to test the 'loadingView'//

- (IBAction)triggerLoadingView:(id)sender {
    if (self.loadingView.hidden) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.loadingView setAlpha:0.8];
        [UIView commitAnimations];
        self.loadingView.hidden = !self.loadingView.hidden;
    } else {
        
        [self.loadingView setAlpha:0];
        [UIView commitAnimations];
        self.loadingView.hidden = !self.loadingView.hidden;
    }
    //return YES;
}

///////////////////////////////////////////////////////////////////////////
//
// Keyboard adjustments
//
///////////////////////////////////////////////////////////////////////////

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameInputTextField) {
        [textField resignFirstResponder];
        // [self dismissKeyboard];
        return NO;
    }
    return YES;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardDidShow: (NSNotification *) notif{

    self.view.frame = CGRectMake(0, -140, self.view.frame.size.width, self.view.frame.size.height);

}

- (void)keyboardDidHide: (NSNotification *) notif{

    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}


@end
