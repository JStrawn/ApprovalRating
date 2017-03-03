//
//  ResultController.h
//  ApprovalRating
//
//  Created by Jerry Chen on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ResultController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) DAO *daoData;

@property (strong, nonatomic) IBOutlet UIView *resultContainerView;
@property (weak, nonatomic) IBOutlet UIView *scoreBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchTermLabel;
@property (weak, nonatomic) IBOutlet UIView *summaryContainerView;

// sentiment score labels
@property (weak, nonatomic) IBOutlet UILabel *posScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *neuScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *negScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

// testing
- (IBAction)dismissButtonPrsd:(id)sender;

@end
