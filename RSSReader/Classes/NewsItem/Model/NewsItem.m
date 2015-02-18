//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"
#import "NewsFeed.h"


@implementation NewsItem

- (NewsItem*) initWithTitle: (NSString*) title andCreationDate: (NSDate*) creationDate andContent: (NSString *) content andUrl: (NSURL*) url
{
    self = [super init];
    
    _title = title;
    _creationDate = creationDate;
    _content = content;
    _url = url;
    _isRead = NO;
    
    return self;
}

@end
