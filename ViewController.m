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
}

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

    self.nameInputTextField.delegate = self;
#pragma mark PLACEHOLDER, comment out for real searching
    self.nameInputTextField.text = @"Bernie Sanders";
    
    self.navigationItem.leftBarButtonItem= infoButton;
    
    // submit button
    self.submitButton.backgroundColor = UIColorFromRGB(0x6da7d3);
    self.submitButton.layer.cornerRadius = 5;
    
    
    self.dao = [[DAO alloc]init];
    
    
    
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
    self.dao = [[DAO alloc]init];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)receivedNotification:(NSNotification*)notification
{
    if ([[notification name] isEqualToString:@"Address Found"]) {
//        NSLog(@"pos %d, neg %d, neu %d", self.dao.positiveSentimentValue, self.dao.negativeSentimentValue, self.dao.neutralSentimentValue);
    }
}


- (IBAction)submitButtonPrsd:(id)sender {
    
    self.dao.userSearchString = self.nameInputTextField.text;
    self.dao.noSpacesUserSearchString = [self.dao.userSearchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    self.dao.fixedUserSearchString = [self.dao.noSpacesUserSearchString stringByAppendingString:@"%20"];
    
    [self.dao getPositiveSentimentValues];
    [self.dao getNegativeSentimentValues];
    [self.dao getNeutralSentimentValues];
    [self.dao getNewsStories];
    
    [self resultLauncher:self];
    
}

- (IBAction)resultLauncher:(id)sender {
    ResultController *resultController = [[ResultController alloc] init];
    [self presentViewController:resultController animated:YES completion:nil];
}
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
