//
//  ResultController.m
//  ApprovalRating
//
//  Created by Jerry Chen on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "ResultController.h"
#import "CustomCell.h"

@interface ResultController ()
@property (weak, nonatomic) IBOutlet UILabel *postiveScoreResult;
@property (weak, nonatomic) IBOutlet UILabel *neutralScoreResult;
@property (weak, nonatomic) IBOutlet UILabel *negativeScoreResult;
@property (weak, nonatomic) IBOutlet UILabel *approvalRatingResult;

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Initializing daoData
    self.sharedManager = [DAO sharedManager];
    self.
    
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
    
    // Initializing Methods
    self.posScoreLabel.text = [NSString stringWithFormat:@"%d", self.sharedManager.positiveSentimentValue];
    self.neuScoreLabel.text = [NSString stringWithFormat:@"%d", self.sharedManager.neutralSentimentValue];
    self.negScoreLabel.text = [NSString stringWithFormat:@"%d", self.sharedManager.negativeSentimentValue];
    
    [self approvalRatingCalculated];
    
}


-(void)approvalRatingCalculated {
    
    double totalresults = self.sharedManager.positiveSentimentValue + self.sharedManager.neutralSentimentValue + self.sharedManager.negativeSentimentValue;
    
    double calculatedPercentage = self.sharedManager.positiveSentimentValue/totalresults * 100;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%.f%%",calculatedPercentage];
    self.searchTermLabel.text = self.sharedManager.userSearchString;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.sharedManager.newsStories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    self.currentNewsStory = [[NewsStory alloc]init];
    self.currentNewsStory = self.sharedManager.newsStories[indexPath.row];
    
    cell.headline.text = self.currentNewsStory.newsTitle;
    
    UIImage *newsImage = [self getImageFromURL:self.currentNewsStory.imageURL withTableViewCell:cell];
    cell.newsImageView.image = newsImage;
    
    return cell;
}



//Outlets will begin here//

- (IBAction)dismissButtonPrsd:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *) getImageFromURL:(NSString *)fileURL withTableViewCell:(CustomCell*)cell{
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // Declare your local data outside the block.
    // `__block` specifies that the variable can be modified from within the block.
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    __block UIImage *result = [UIImage imageWithData:imageData];
    
    dispatch_sync(concurrentQueue, ^{
        // Do something with `localData`...
        cell.newsImageView.image = result;
    });
    
    // `localData` now contains your the data.
    return result;
}


@end
