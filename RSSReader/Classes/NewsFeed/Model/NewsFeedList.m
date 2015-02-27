//
//  NewsFeedSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedList.h"

NSString const * NewsFeedListAddNewsFeedNotification = @"NewsFeedListAddNewsFeedNotification";
NSString const * NewsFeedListAddNewsFeedFailNotification = @"NewsFeedListAddNewsFeedFailNotification";
NSString const * NewsFeedListRemoveNewsFeedNotification = @"NewsFeedListRemoveNewsFeedNotification";
NSString const * NewsFeedTitleKey = @"NewsFeedTitleKey";

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
        
        [self postNotificationWithName:(NSString *) NewsFeedListAddNewsFeedNotification];
    }];

    return  self;
}

- (NSArray *) newsFeeds
{
    return _newsFeeds;
}

- (void)addNewsFeed: (NSURL *) newsFeedurl
{
    BOOL isConteins = NO;
    NewsFeed * item;
    for (NewsFeed * newsFeed in _newsFeeds) {
        if ([newsFeed.url.absoluteString isEqualToString: newsFeedurl.absoluteString]){
            isConteins = YES;
            item = newsFeed;
        }
    }
    if (!isConteins)
    {
        item = [[NewsFeed alloc]initWithTitle:newsFeedurl.absoluteString
                                              andURL:newsFeedurl
                                            andImage:nil];
    
        __block NewsFeed * updateItem = item;
        [_provider addNewsFeed:updateItem completionBlock:^(NSError *error) {
            if (error == nil){
                [_newsFeeds addObject: updateItem];
                [updateItem update];
                [self postNotificationWithName:(NSString*) NewsFeedListAddNewsFeedNotification];
            }
        }];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)NewsFeedListAddNewsFeedFailNotification
                                                                 object:self
                                                               userInfo:@{NewsFeedTitleKey:item.title}];
    }
}

- (void)removeNewsFeed: (NewsFeed *) newsFeed{
    __block NewsFeed * updateNewsFeed = newsFeed;
    
    [_provider removeNewsFeed:updateNewsFeed completionBlock:^(NSError *error) {
        if (error == nil){
            [_newsFeeds removeObject:updateNewsFeed];
            [self postNotificationWithName:(NSString*) NewsFeedListRemoveNewsFeedNotification];
        }
    }];
    
}

- (void) postNotificationWithName: (NSString*) notificationName{
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)notificationName
                                                        object:self];
}

@end
