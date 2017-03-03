//
//  ResultController.m
//  ApprovalRating
//
//  Created by Jerry Chen on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "ResultController.h"

@interface ResultController ()
@property (weak, nonatomic) IBOutlet UILabel *postiveScoreResult;
@property (weak, nonatomic) IBOutlet UILabel *neutralScoreResult;
@property (weak, nonatomic) IBOutlet UILabel *negativeScoreResult;
@property (weak, nonatomic) IBOutlet UILabel *approvalRatingResult;

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initializing daoData
    self.sharedManager = [DAO sharedManager];
    
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
    
    //Initializing Methods//
    [self talliedSentimentResults];
    [self approvalRatingCalculated];
    
}

-(void)talliedSentimentResults {
    self.posScoreLabel.text = [NSString stringWithFormat:@"%d", self.daoData.positiveSentimentValue];
    self.neuScoreLabel.text = [NSString stringWithFormat:@"%d", self.daoData.neutralSentimentValue];
    self.negScoreLabel.text = [NSString stringWithFormat:@"%d", self.daoData.negativeSentimentValue];
}

-(void)approvalRatingCalculated {
    
    double totalresults = self.daoData.positiveSentimentValue + self.daoData.neutralSentimentValue + self.daoData.negativeSentimentValue;
    
    double calculatedPercentage = self.daoData.positiveSentimentValue/totalresults;
    
    self.approvalRatingResult.text = [NSString stringWithFormat:@"%f",calculatedPercentage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.daoData.newsStories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"This is a test";
    return cell;
}

//Outlets will begin here//

- (IBAction)dismissButtonPrsd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
