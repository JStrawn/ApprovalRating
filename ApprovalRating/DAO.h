//
//  DAO.h
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAO : NSObject

@property (strong, nonatomic) NSString* userSearchString;

@property int positiveSentimentValue;
@property int negativeSentimentValue;
@property int neutralSentimentValue;
@property int numberOfStories;

- (void)getSentimentValues;
- (void)dataRequest:(NSString*)urlString;



@end
