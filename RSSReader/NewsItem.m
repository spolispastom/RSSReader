//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content andLink: (NSString *) link
{
    
    self = [super init];
    
    _title = title;
    _creationDate = creationDate;
    _content = content;
    _link = link;
    
    return self;
}


- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content
{
    return [self initWithTitle:title andCreationDate:creationDate andContent:content andLink:nil];
}

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate
{
    return [self initWithTitle:title andCreationDate:creationDate andContent:nil andLink:nil];
}

@end
