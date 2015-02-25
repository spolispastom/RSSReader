//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"
#import "NewsFeed.h"

NSString const * NewsItemDidReadNotification = @"NewsItemDidReadNotification";

@implementation NewsItem

- (instancetype) initWithTitle: (NSString*) title andCreationDate: (NSDate*) creationDate andContent: (NSString *) content andUrl: (NSURL*) url
{
    self = [super init];
    
    _title = title;
    _creationDate = creationDate;
    _content = content;
    _url = url;
    _isRead = NO;
    
    return self;
}

- (void) setIsRead: (BOOL) isRead{
    _isRead = isRead;
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)NewsItemDidReadNotification object:self];
}

@end
