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
    
    self.myAPIToken = @"bdfe913e-d37f-4f75-83a5-3c41b7443483";
    
#pragma mark This is a dummy request, comment out line 26 when using user generated search
    //self.userSearchString = @"Bernie Sanders";
    //self.userSearchString = self.vc.nameInputTextField.text;


    return self;
}


- (void)getPositiveSentimentValues {
    
    NSMutableString *urlString = [[NSMutableString alloc]init];

    //create the url string
    [urlString appendString:@"http://webhose.io/search?token="];
    [urlString appendString:self.myAPIToken];
    [urlString appendString:@"&format=json&q="];
    [urlString appendString:self.fixedUserSearchString];
    [urlString appendString:@"person.positive%3A%22"];
    [urlString appendString:self.noSpacesUserSearchString];
    [urlString appendString:@"%22%20(site_type%3Anews%20OR%20site_type%3Ablogs)"];
    
    [self dataRequestForSentiments:urlString sentType:POSITIVE];
        
}

- (void)getNegativeSentimentValues {
    
    NSMutableString *urlString = [[NSMutableString alloc]init];

    
    //create the url string
    [urlString appendString:@"http://webhose.io/search?token="];
    [urlString appendString:self.myAPIToken];
    [urlString appendString:@"&format=json&q="];
    [urlString appendString:self.fixedUserSearchString];
    [urlString appendString:@"person.negative%3A%22"];
    [urlString appendString:self.noSpacesUserSearchString];
    [urlString appendString:@"%22%20(site_type%3Anews%20OR%20site_type%3Ablogs)"];
    
    [self dataRequestForSentiments:urlString sentType:NEGATIVE];
    
}

- (void)getNeutralSentimentValues {
    
    NSMutableString *urlString = [[NSMutableString alloc]init];
    
    //create the url string
    [urlString appendString:@"http://webhose.io/search?token="];
    [urlString appendString:self.myAPIToken];
    [urlString appendString:@"&format=json&q="];
    [urlString appendString:self.fixedUserSearchString];
    [urlString appendString:@"person.neutral%3A%22"];
    [urlString appendString:self.noSpacesUserSearchString];
    [urlString appendString:@"%22%20(site_type%3Anews%20OR%20site_type%3Ablogs)"];
    
    [self dataRequestForSentiments:urlString sentType:NEUTRAL];
    
}

-(void)getNewsStories {
    
    NSMutableString *urlString = [[NSMutableString alloc]init];
    
    //create the url string
    [urlString appendString:@"http://webhose.io/search?token="];
    [urlString appendString:self.myAPIToken];
    [urlString appendString:@"&format=json&q="];
    [urlString appendString:self.fixedUserSearchString];
    [urlString appendString:@"person%3A%22"];
    [urlString appendString:self.noSpacesUserSearchString];
    [urlString appendString:@"%22%20(site_type%3Anews%20OR%20site_type%3Ablogs)"];

    [self dataRequestForNewsStories:urlString];
    
}

- (void) dataRequestForSentiments:(NSString*)urlString sentType:(int)sentimentType {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

        //convert data into array
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        NSNumber *numOfStories = [dictionary objectForKey:@"totalResults"];
        self.numberOfStories = [numOfStories doubleValue];
        
        if (sentimentType == 0) {
            self.positiveSentimentValue = self.numberOfStories;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Positive Finished" object:self];
            NSLog(@" ############# positive sentiment score: %d", self.positiveSentimentValue);

        } else if (sentimentType == 1) {
            self.negativeSentimentValue = self.numberOfStories;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Negative Finished" object:self];

        } else if (sentimentType == 2) {
            self.neutralSentimentValue = self.numberOfStories;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Neutral Finished" object:self];

        }
        
    }];
    [dataTask resume];
}

- (void) dataRequestForNewsStories:(NSString*)urlString {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //convert data into dictionary
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        // NSLog(@"Dictionary: %@", dictionary);
        
        //for in loop
        NSDictionary *posts = [dictionary objectForKey:@"posts"];
        //NSDictionary *thread = [posts objectForKey:@"thread"];
        for (NSDictionary *currentThread in posts) {
            NSString *title = [currentThread objectForKey:@"title"];
            NSString *url = [currentThread objectForKey:@"url"];
            NSString *imageURL = [currentThread objectForKey:@"main_image"];
            NSString *source = [currentThread objectForKey:@"site"];
            
            self.newsStories = [[NSMutableArray alloc]init];
            NewsStory *currentStory = [[NewsStory alloc]initWithTitle:title andURL:url andImageURL:imageURL andSource:source];
            NSString *performanceScore = [currentThread objectForKey:@"performance_score"];
            double performanceDouble = performanceScore.doubleValue;
            currentStory.score = performanceDouble;
            
            //ResultController *rc = [[ResultController alloc]init];
            
            
            [self.newsStories addObject:currentStory];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"News Finished" object:self];

        }
        
    }];
    [dataTask resume];
    });
    
}





@end
