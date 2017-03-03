//
//  ResultController.h
//  ApprovalRating
//
//  Created by Jerry Chen on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *resultContainerView;
@property (weak, nonatomic) IBOutlet UIView *scoreBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchTermLabel;

// sentiment score labels
@property (weak, nonatomic) IBOutlet UILabel *posScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *neuScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *negScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

// testing
- (IBAction)dismissButtonPrsd:(id)sender;

@end
