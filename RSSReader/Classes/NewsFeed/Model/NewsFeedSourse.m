//
//  NewsFeedSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedSourse.h"

@interface NewsFeedSourse()

@property (nonatomic) NSMutableDictionary * newsSourses;
@property (weak, nonatomic) ProviderDataMedel * provider;

@end

@implementation NewsFeedSourse

- (NewsFeedSourse *) initWithDelegate: (id<NewsFeedSourseDelegate>) delegate
{
    self = [super init];
    
    _provider = [ProviderDataMedel instance];
    [_provider setDelegate: self];
    
    _delegate = delegate;
    [_delegate newsSourse: self didGetNewsFeed: [self newsFeeds]];
    
    _newsSourses = [[NSMutableDictionary alloc] init];
    
    return  self;
}

- (NSArray *) newsFeeds
{
    return [[_provider getNewsFeeds] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NewsFeed * item1 = (NewsFeed *)obj1;
        NewsFeed * item2 = (NewsFeed *)obj2;
        if ([item1.title compare: item2.title])
            return NSOrderedDescending;
        else if (item1.title < item2.title)
            return NSOrderedAscending;
        else return NSOrderedSame;
    }];
}

- (void)providerDataMedelDelegate:(ProviderDataMedel*) provider didNewsFeedCollectionChanget:(NSArray *) newsFeeds{
    [_delegate newsSourse:self didGetNewsFeed: [self newsFeeds]];
}


- (void)addNewsFeed: (NSString *) newsFeed
{
    NewsFeed * item = [[NewsFeed alloc]initWithTitle:newsFeed
                                              andURL:[NSURL URLWithString:newsFeed]
                                            andImage:nil];
    
    [[self getNewsSourseFromNewsFeed:item] update];
    [_provider addNewsFeed:item];
}

- (void)removeNewsFeed: (NewsFeed *) newsFeed
{
    [_newsSourses removeObjectForKey:newsFeed.url];
    
    [_provider removeNewsFeed:newsFeed];
    
    [_delegate newsSourse:self didGetNewsFeed:[self newsFeeds]];
}

- (NewsSourse *) getNewsSourseFromNewsFeed: (NewsFeed *) newsFeed;
{
    NewsSourse * sourse = [_newsSourses objectForKey:newsFeed.url];
    
    if (!sourse)
    {
        sourse = [[NewsSourse alloc] initWithURL:newsFeed
                               andSourseDelegate:nil
                                andTitleDelegate:self];
        [_newsSourses setObject: sourse forKey: newsFeed.url];
        
    }
    return sourse;
}

- (void)newsSourse:(NewsSourse *) sourse didParseTitle: (NSString *) title andImage:(NSData *)image
{
    [_provider changeNewsFeedFromURL:sourse.url ofTitle:title andImage:image];
    [_delegate newsSourse:self didGetNewsFeed:[self newsFeeds]];
}

@end
