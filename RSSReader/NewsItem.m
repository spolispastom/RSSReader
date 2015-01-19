//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content
{
    self = [super init];
    
    _title = title;
    _creationDate = creationDate;
    _content = content;
    
    return self;
}

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate
{
    return [self initWithTitle: title andCreationDate: creationDate andContent: nil];
}

@end
