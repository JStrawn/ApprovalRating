//
//  DAO.h
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAO : NSObject <NSURLSessionDownloadDelegate>

@property (nonatomic, weak) id<NSURLSessionDownloadDelegate> delegate;

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
