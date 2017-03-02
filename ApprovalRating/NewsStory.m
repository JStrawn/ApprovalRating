//
//  NewsStory.m
//  ApprovalRating
//
//  Created by Juliana Strawn on 3/2/17.
//  Copyright © 2017 JStrawn. All rights reserved.
//

#import "NewsStory.h"

@implementation NewsStory

- (instancetype)initWithTitle:(NSString*)Title andURL:(NSString*)URL andImageURL:(NSString*)imageURL
{
    self = [super init];
    if (self) {
        self.newsTitle = Title;
        self.url = URL;
        self.imageURL = imageURL;

    }
    return self;
}

@end
