//
//  DAO.m
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "DAO.h"
#import "AppDelegate.h"
#import "NewsStory.h"
#import "ResultController.h"
#import "ViewController.h"

@interface DAO ()

@end

@implementation DAO: NSObject


+ (id)sharedManager {
    static DAO *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    
    self = [super init];
    
    self.myAPIToken = @"69a67756-7109-4559-b2c0-9784eec41c5c";
    
    ViewController *vc = [[ViewController alloc]init];
    self.userSearchString = vc.nameInputTextField.text;

    return self;
}


- (void)getPositiveSentimentValues {
    
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=person.positive%%3A%%22%@%%22&sort=performance_score",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    [self dataRequestForSentiments:urlString sentType:POSITIVE];
        
}


- (void)getNegativeSentimentValues {
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=person.negative%%3A%%22%@%%22&sort=performance_score",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    [self dataRequestForSentiments:urlString sentType:NEGATIVE];
    
}


- (void)getNeutralSentimentValues {
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=person.neutral%%3A%%22%@%%22&sort=performance_score",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    [self dataRequestForSentiments:urlString sentType:NEUTRAL];
    
}


-(void)getNewsStories {
    
    NSMutableString *urlString = [[NSMutableString alloc]init];
    
    //create the url string
    [urlString appendString:@"http://webhose.io/search?token="];
    [urlString appendString:self.myAPIToken];
    [urlString appendString:@"&format=json&q="];
    [urlString appendString:@"person%3A%22"];
    [urlString appendString:self.noSpacesUserSearchString];
    [urlString appendString:@"%22%20(site_type%3Anews)&sort=relevancy"];

    [self dataRequestForNewsStories:urlString];
    
}

- (void) dataRequestForSentiments:(NSString*)urlString sentType:(int)sentimentType {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"@%@", urlString);
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        

        //convert data into array
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        NSNumber *numOfStories = [dictionary objectForKey:@"totalResults"];
        self.numberOfStories = [numOfStories doubleValue];
        
        if (sentimentType == 0) {
            self.positiveSentimentValue = self.numberOfStories;
            //use dispatch async to get these notifications on the MAIN thread because itherwise they will be pahhening asynchronusly
            dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Positive Finished" object:self];
            NSLog(@" ############# positive sentiment score: %d", self.positiveSentimentValue);
            });


        } else if (sentimentType == 1) {
            dispatch_async(dispatch_get_main_queue(),^{
            self.negativeSentimentValue = self.numberOfStories;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Negative Finished" object:self];
            NSLog(@" ############# negative sentiment score: %d", self.negativeSentimentValue);
            });


        } else if (sentimentType == 2) {
            self.neutralSentimentValue = self.numberOfStories;
            dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Neutral Finished" object:self];
            NSLog(@" ############# neutral sentiment score: %d", self.neutralSentimentValue);
            });
        }
        
    }];
    [dataTask resume];
}

- (void) dataRequestForNewsStories:(NSString*)urlString {
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //convert data into dictionary
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        // NSLog(@"Dictionary: %@", dictionary);
        
        //for in loop
        
        self.newsStories = [[NSMutableArray alloc]init];
        
        //NSDictionary *thread = [[NSDictionary alloc]init];
        
        NSArray *posts = [dictionary objectForKey:@"posts"];
        //thread = [posts objectForKey:@"thread"];

        for (NSDictionary *currentStory in posts) {
            NSDictionary *threadDictionary = [currentStory objectForKey:@"thread"];
            NSString *site = [threadDictionary objectForKey:@"site"];
            NSString *imageURL = [threadDictionary objectForKey:@"main_image"];
            NSString *title = [threadDictionary objectForKey:@"title"];
            NSString *url = [threadDictionary objectForKey:@"url"];
            
            NewsStory *currentStory = [[NewsStory alloc]initWithTitle:title andURL:url andImageURL:imageURL andSource:site];
            
            NSString *performanceScore = [threadDictionary objectForKey:@"performance_score"];
            double performanceDouble = performanceScore.doubleValue;
            currentStory.score = performanceDouble;
            
            //ResultController *rc = [[ResultController alloc]init];
            
            [self.newsStories addObject:currentStory];
            

        }
        dispatch_async(dispatch_get_main_queue(),^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"News Finished" object:self];
        });

    }];
    [dataTask resume];
    
}





@end
