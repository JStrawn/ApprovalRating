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
    // Do any additional setup after loading the view from its nib.
    self.dao = [[DAO alloc]init];
    [self.dao getSentimentValues];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apiCallComplete:) name:@"notificationName" object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)apiCallComplete:(NSNotification*)notification
{
 //refresh the tableview and other stuff - this is called every time an api call completes
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
