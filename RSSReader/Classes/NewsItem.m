//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 28.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"
#import "NewsFeed.h"


@implementation NewsItem

@dynamic content;
@dynamic creationDate;
@dynamic isRead;
@dynamic title;
@dynamic url;
@dynamic newsFeed;


- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content andLink: (NSString *) link
                  andContext:(NSManagedObjectContext *) context
{
    self = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext: context];
    
    [self setValue:title forKey:@"title"];
    [self setValue:creationDate forKey:@"creationDate"];
    [self setValue:content forKey:@"content"];
    [self setValue:link forKey:@"url"];
    //[self setValue:NO forKey:@"isRead"];
    
    return self;
}

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content
                  andContext:(NSManagedObjectContext *) context
{
    return [self initWithTitle:title andCreationDate:creationDate andContent:content andLink:nil andContext:context];
}


- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContext:(NSManagedObjectContext *) context
{
    return [self initWithTitle:title andCreationDate:creationDate andContent:nil andLink:nil andContext:context];
}

@end
