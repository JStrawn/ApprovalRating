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
    self.myAPIToken = @"PASTE YOUR API TOKEN HERE";
    
    ViewController *vc = [[ViewController alloc]init];
    self.userSearchString = vc.nameInputTextField.text;
    
    return self;
}


- (void)getPositiveSentimentValues {
    
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=person.positive%%3A%%22%@%%22",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    //NSLog(@"%@", urlString);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        if (jsonError) {
                            NSLog(@"%@", jsonError.localizedDescription);
                            NSString *dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"%@", dataAsString);
                            
                        } else {
                            // Success Parsing JSON
                            // Log NSDictionary response:
                            NSNumber *numOfStories = [jsonResponse objectForKey:@"totalResults"];
                            self.positiveSentimentValue = [numOfStories doubleValue];
                            

                                dispatch_async(dispatch_get_main_queue(),^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Positive Finished" object:self];
                                    NSLog(@" ############# positive sentiment score: %d", self.positiveSentimentValue);
                                });
                                
                            
                        }
                    }  else {
                        //Web server is returning an error
                    }
                } else {
                    // Fail
                    NSLog(@"error : %@", error.description);
                }
            }] resume];

    
}


- (void)getNegativeSentimentValues {
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=person.negative%%3A%%22%@%%22",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    //NSLog(@"%@", urlString);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        if (jsonError) {
                            NSLog(@"%@", jsonError.localizedDescription);
                            NSString *dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"%@", dataAsString);
                            
                        } else {
                            // Success Parsing JSON
                            // Log NSDictionary response:
                            NSNumber *numOfStories = [jsonResponse objectForKey:@"totalResults"];
                            self.negativeSentimentValue = [numOfStories doubleValue];
                            
                                
                                dispatch_async(dispatch_get_main_queue(),^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Negative Finished" object:self];
                                    NSLog(@" ############# negative sentiment score: %d", self.negativeSentimentValue);
                                });
                                
                        }
                    }  else {
                        //Web server is returning an error
                    }
                } else {
                    // Fail
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
    
}


- (void)getNeutralSentimentValues {
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=person.neutral%%3A%%22%@%%22",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    //NSLog(@"%@", urlString);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        if (jsonError) {
                            NSLog(@"%@", jsonError.localizedDescription);
                            NSString *dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"%@", dataAsString);
                            
                        } else {
                            // Success Parsing JSON
                            // Log NSDictionary response:
                            NSNumber *numOfStories = [jsonResponse objectForKey:@"totalResults"];
                            self.neutralSentimentValue = [numOfStories doubleValue];
                                dispatch_async(dispatch_get_main_queue(),^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Neutral Finished" object:self];
                                    NSLog(@" ############# neutral sentiment score: %d", self.neutralSentimentValue);
                                });
                            
                        }
                    }  else {
                        //Web server is returning an error
                    }
                } else {
                    // Fail
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
    
}


-(void)getNewsStories {
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://webhose.io/search?token=%@&format=json&q=language%%3A(english)%%20person%%3A%%22%@%%22%%20(site_type%%3Anews)&sort=relevancy",
                           self.myAPIToken, self.noSpacesUserSearchString];
    
    //NSLog(@"%@", urlString);
    
    [self dataRequestForNewsStories:urlString];
    
}



- (void) dataRequestForNewsStories:(NSString*)urlString {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:urlString]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                
                NSLog(@"%@", urlString);
                
                if (!error) {
                    // Success
                    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSError *jsonError;
                        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                        
                        if (jsonError) {
                            NSLog(@"%@", jsonError.localizedDescription);
                            NSString *dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                            NSLog(@"%@", dataAsString);
                            
                        } else {
                            // Success Parsing JSON
                            // Log NSDictionary response:
                            //NSLog(@"%@",jsonResponse);
                            
                            self.newsStories = [[NSMutableArray alloc]init];
                            
                            NSArray *posts = [jsonResponse objectForKey:@"posts"];
                            
                            for (NSDictionary *currentStory in posts) {
                                NSDictionary *threadDictionary = [currentStory objectForKey:@"thread"];
                                NSString *site = [threadDictionary objectForKey:@"site"];
                                NSString *imageURL = [threadDictionary objectForKey:@"main_image"];
                                NSString *title = [threadDictionary objectForKey:@"title"];
                                NSString *url = [threadDictionary objectForKey:@"url"];
                                
                                NewsStory *currentStory = [[NewsStory alloc]initWithTitle:title andURL:url andImageURL:imageURL andSource:site];
                                
                                //NSLog(@"%@", currentStory.newsTitle);
                                
                                [self.newsStories addObject:currentStory];
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(),^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"News Finished" object:self];
                            });
                        }
                    }  else {
                        //Web server is returning an error
                    }
                } else {
                    // Fail
                    NSLog(@"error : %@", error.description);
                }
            }] resume];
    

    
}





@end
