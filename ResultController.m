//
//  ResultController.m
//  ApprovalRating
//
//  Created by Jerry Chen on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "ResultController.h"

@interface ResultController ()

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///////////////////////////////////////////////////////////////////////////
    //
    // UI Related
    //
    ///////////////////////////////////////////////////////////////////////////
    self.scoreBackgroundView.layer.cornerRadius = 40;
    self.scoreBackgroundView.layer.masksToBounds = true;
    
    UIImage *exitIcon = [UIImage imageNamed:@"exit.png"];
    [self.dismissButton setImage:exitIcon forState:UIControlStateNormal];
    
    // Gradient background view
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.summaryContainerView.layer.frame;
    gradient.colors = @[(id)UIColorFromRGB(0x121212).CGColor, (id)UIColorFromRGB(0x333333).CGColor];
    [self.summaryContainerView.layer insertSublayer:gradient atIndex:0];
    
    self.scoreBackgroundView.backgroundColor = UIColorFromRGB(0x7abaef);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissButtonPrsd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
