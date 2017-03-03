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

@interface DAO () <NSURLSessionDownloadDelegate>

@end

@implementation DAO: NSObject


- (id)init {
    self.myAPIToken = @"bdfe913e-d37f-4f75-83a5-3c41b7443483";
    
#pragma mark This is a dummy request, comment out line 26 when using user generated search
    self.userSearchString = @"Bernie Sanders";
    self.noSpacesUserSearchString = [self.userSearchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    self.fixedUserSearchString = [self.noSpacesUserSearchString stringByAppendingString:@"%20"];

    return self;
}

- (instancetype)initWithDelegate:(id<NSURLSessionDownloadDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
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
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {

        //convert data into array
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSNumber *numOfStories = [dictionary objectForKey:@"totalResults"];
        self.numberOfStories = [numOfStories doubleValue];
        
        if (sentimentType == 0) {
            self.positiveSentimentValue = self.numberOfStories;
        } else if (sentimentType == 1) {
            self.negativeSentimentValue = self.numberOfStories;
        } else if (sentimentType == 2) {
            self.neutralSentimentValue = self.numberOfStories;
        }
            
        //[self.delegate didRetreiveInfo:data];
        // NSNotification broadcast here
        //how to bring this back to the main queue
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Address Found" object:self];

            
        });

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
    });
    
}





@end
