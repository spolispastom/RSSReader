//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"

@implementation NewsItem

- (NewsItem *) initFromTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content
{
    self = [super init];
    
    _Title = title;
    _CreationDate = creationDate;
    _Content = content;
    
    return self;
}

- (NewsItem *) initFromTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate
{
    return [self initFromTitle: title andCreationDate: creationDate andContent: nil];
}

@end
