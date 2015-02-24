//
//  NewsFeedSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedList.h"
#import "NewsFeedSerializer.h"

@interface NewsFeedList()

@property (weak, nonatomic) DataModelProvider * provider;
@property (nonatomic) id<NewsFeedSerializerPersistence> serializer;
@property (nonatomic) NSArray * newsFeeds;

@end

@implementation NewsFeedList

- (instancetype) initWithDelegate: (id<NewsFeedListDelegate>) delegate
{
    self = [super init];
    
    _provider = [DataModelProvider instance];
    
    _delegate = delegate;

    [_provider getNewsFeedsWithSerializer:[self serializer] completionBlock:^(NSArray *newsFeeds, NSError *error) {
        _newsFeeds = newsFeeds;
        [_delegate newsFeedList: self didGetNewsFeed: _newsFeeds];
    }];

    return  self;
}

- (NSArray *) newsFeeds
{
    return _newsFeeds;
}

- (void)addNewsFeed: (NSString *) newsFeed
{
    NewsFeed * item = [[NewsFeed alloc]initWithTitle:newsFeed
                                              andURL:[NSURL URLWithString:newsFeed]
                                            andImage:nil];
    
    __block NewsFeed * updateItem = item;
    [_provider addNewsFeedWithURL: item.url.absoluteString NewsFeed:item withSerializer:[self serializer] completionBlock:^(NSArray *newsFeeds, NSError *error) {
        if (error == nil){
            _newsFeeds = newsFeeds;
            [_delegate newsFeedList:self didGetNewsFeed:_newsFeeds];
        }
        
        [updateItem update];
    }];
}

- (void)removeNewsFeed: (NewsFeed *) newsFeed
{
    [_provider removeNewsFeedWithURL:newsFeed.url.absoluteString withSerializer:[self serializer] completionBlock:^(NSArray *newsFeeds, NSError *error) {
        if (error != nil){
            _newsFeeds = newsFeeds;
            [_delegate newsFeedList:self didGetNewsFeed: _newsFeeds];
        }
    }];
    
}

- (void)NewsFeed:(NewsFeed *)sourse didParseTitle:(NSString *)title andImage:(NSData *)image
{
    [_delegate newsFeedList:self didGetNewsFeed:_newsFeeds];
}


-(id<NewsFeedSerializerPersistence>) serializer{
    if (_serializer == nil){
        _serializer = [[NewsFeedSerializer alloc] init];
    }
    return _serializer;
}

@end
