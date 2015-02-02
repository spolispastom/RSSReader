//
//  NewsFeed.m
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeed.h"
#import "NewsItem.h"


@implementation NewsFeed

@dynamic title;
@dynamic url;
@dynamic image;
@dynamic newsItems;

- (NewsFeed *) initWithURL: (NSString *) url ManagedObjectContext:(NSManagedObjectContext *) context
{
    self = [NSEntityDescription insertNewObjectForEntityForName:@"NewsFeed" inManagedObjectContext: context];
    
    self.title = url;
    self.url = url;
    
    return  self;
}

@end
