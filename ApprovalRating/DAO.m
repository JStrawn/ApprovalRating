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

@interface DAO ()

@end

@implementation DAO: NSObject



- (void)getSentimentValues {
    
    NSMutableString *urlString = [[NSMutableString alloc]init];
    NSString *myAPIToken = @"bdfe913e-d37f-4f75-83a5-3c41b7443483";
    
#pragma mark This is a dummy request, comment out line 26 when using user generated search
    self.userSearchString = @"Bernie Sanders";
    NSString *noSpacesUserSearchString = [self.userSearchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *fixedUserSearchString = [noSpacesUserSearchString stringByAppendingString:@"%20"];
    
    //create the url string
    [urlString appendString:@"http://webhose.io/search?token="];
    [urlString appendString:myAPIToken];
    [urlString appendString:@"&format=json&q="];
    [urlString appendString:fixedUserSearchString];
    [urlString appendString:@"person.positive%3A%22"];
    [urlString appendString:noSpacesUserSearchString];
    [urlString appendString:@"%22%20(site_type%3Anews%20OR%20site_type%3Ablogs)"];
    
    [self dataRequestForSentiments: urlString];
    NSLog(@"%d", self.numberOfStories);
    
    [self dataRequestForNewsStories:urlString];
    
}

- (int) dataRequestForSentiments:(NSString*)urlString {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //convert data into array
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSNumber *numOfStories = [dictionary objectForKey:@"totalResults"];
        self.numberOfStories = [numOfStories doubleValue];
        NSLog(@"%d", self.numberOfStories);
    }];
    [dataTask resume];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"apiCallComplete" object:self];

    return self.numberOfStories;

}

- (void) dataRequestForNewsStories:(NSString*)urlString {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //convert data into dictionary
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"Dictionary: %@", dictionary);
        
        //for in loop
        NSDictionary *posts = [dictionary objectForKey:@"posts"];
        //NSDictionary *thread = [posts objectForKey:@"thread"];
        for (NSDictionary *currentThread in posts) {
            NSString *title = [currentThread objectForKey:@"title"];
            NSString *url = [currentThread objectForKey:@"url"];
            NSString *imageURL = [currentThread objectForKey:@"main_image"];
            
            self.newsStories = [[NSMutableArray alloc]init];
            NewsStory *currentStory = [[NewsStory alloc]initWithTitle:title andURL:url andImageURL:imageURL];
            NSString *performanceScore = [currentThread objectForKey:@"performance_score"];
            double performanceDouble = performanceScore.doubleValue;
            currentStory.score = performanceDouble;
            [self.newsStories addObject:currentStory];
        }
        
    }];
    [dataTask resume];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"apiCallComplete" object:self];

    
}





@end
