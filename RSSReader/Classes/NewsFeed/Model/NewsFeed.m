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

- (NewsFeed *) initWithTitle: (NSString *) title andURL: (NSURL*) url andImage: (NSData *) imageData
{
    self = [super init];
    
    _title = title;
    _url = url;
    _imageData = imageData;
    _newsItems = nil;
    
    return self;
}
@end
