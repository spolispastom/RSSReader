//
//  NewsFeedSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedList.h"

NSString const * NewsFeedListDidChangeNotification = @"NewsFeedListDidChangeNotification";
NSString const * NewsFeedListChangeType = @"NewsFeedListChangeType";

@interface NewsFeedList()

@property (weak, nonatomic) DataModelProvider * provider;
@property (nonatomic) NSMutableArray * newsFeeds;

@end

@implementation NewsFeedList

- (instancetype) init
{
    self = [super init];
    
    _provider = [DataModelProvider instance];
    
    _newsFeeds = [NSMutableArray new];
    [_provider getNewsFeedsWithCompletionBlock:^(NSArray *newsFeeds, NSError *error) {
        
        [_newsFeeds addObjectsFromArray: newsFeeds];
        for (NewsFeed * newsFeed in _newsFeeds) {
            [self addObserverNewsFeed:newsFeed];
        }
        
        [self postNotification:NewsFeedListChangeTypeAddNewsFeeds];
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
    [_provider addNewsFeed:updateItem completionBlock:^(NSError *error) {
        if (error == nil){
            [_newsFeeds addObject: updateItem];
            [updateItem downloadAgain];
            [self postNotification:NewsFeedListChangeTypeAddNewsFeeds];
            [self addObserverNewsFeed:updateItem];
        }
    }];
}

- (void)removeNewsFeed: (NewsFeed *) newsFeed{
    __block NewsFeed * updateNewsFeed = newsFeed;
    
    [_newsFeeds removeObject:updateNewsFeed];
    [_provider removeNewsFeed:updateNewsFeed completionBlock:^(NSError *error) {
        if (error != nil){
            [self removeObserverNewsFeed:updateNewsFeed];
            [self postNotification:NewsFeedListChangeTypeRemoveNewsFeed];
        }
    }];
    
}

- (void) postNotification: (int) newsFeedListChangeType{
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)NewsFeedListDidChangeNotification
                                                        object:self
                                                      userInfo:@{NewsFeedListChangeType : [NSNumber numberWithInt:newsFeedListChangeType]}];
}

- (void) addObserverNewsFeed: (NewsFeed *) newsFeed{
    [[NSNotificationCenter defaultCenter] addObserverForName:(NSString*)NewsFeedDidChangeNotification
                                                      object:newsFeed
                                                       queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
                                                           [self postNotification:NewsFeedListChangeTypeAddNewsFeeds];
                                                       }];
}
- (void) removeObserverNewsFeed: (NewsFeed *) newsFeed{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(NSString*)NewsFeedDidChangeNotification object:newsFeed];
}

@end
