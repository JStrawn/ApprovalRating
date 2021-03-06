//
//  ResultController.h
//  ApprovalRating
//
//  Created by Jerry Chen on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"
#import "NewsStory.h"
#import "CustomCell.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ResultController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) DAO *sharedManager;

@property (retain, nonatomic) NewsStory *currentNewsStory;

@property (strong, nonatomic) IBOutlet UIView *resultContainerView;
@property (weak, nonatomic) IBOutlet UIView *scoreBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchTermLabel;
@property (weak, nonatomic) IBOutlet UIView *summaryContainerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// sentiment score labels
@property (weak, nonatomic) IBOutlet UILabel *posScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *neuScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *negScoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

// sentiment scores
@property int positiveScore;
@property int negativeScore;
@property int neutralScore;

// testing
- (IBAction)dismissButtonPrsd:(id)sender;

@end
