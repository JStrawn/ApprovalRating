//
//  NewsStory.h
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsStory : NSObject

@property (strong, nonatomic)NSString *newsTitle;
@property (strong, nonatomic)NSString *url;
@property (strong, nonatomic)NSString *imageURL;
@property (strong, nonatomic)NSString *source;
@property double score;

- (instancetype)initWithTitle:(NSString*)Title andURL:(NSString*)URL andImageURL:(NSString*)imageURL andSource:(NSString*)site;


@end
