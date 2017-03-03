//
//  DAO.h
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ViewController.h"

@interface DAO : NSObject

//@property (strong, nonatomic) ViewController *vc;

+ (id)sharedManager;

@property (strong, nonatomic) NSString* userSearchString;
@property (strong, nonatomic) NSString* noSpacesUserSearchString;
@property (strong, nonatomic) NSString* fixedUserSearchString;

@property (strong, nonatomic) NSMutableArray* newsStories;
@property (strong, nonatomic) NSString *myAPIToken;

// Sentiment Counter
@property int positiveSentimentValue;
@property int negativeSentimentValue;
@property int neutralSentimentValue;

typedef enum {
        POSITIVE,
        NEGATIVE, 
        NEUTRAL

} sentimentType;

@property int numberOfStories;

- (void)getPositiveSentimentValues;
- (void)getNegativeSentimentValues;
- (void)getNeutralSentimentValues;
- (void)getNewsStories;


- (void) dataRequestForSentiments:(NSString*)urlString sentType:(int)sentimentType;
- (void) dataRequestForNewsStories:(NSString*)urlString;



@end
