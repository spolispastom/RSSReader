//
//  ProviderDataMedel.h
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedPersistence.h"
#import "NewsFeed.h"
#import "NewsItem.h"

extern NSString const * DataModelProviderError;

enum {
    DataModelProviderErrorAttemptAddExistingNewsFeed,
    DataModelProviderErrorSaving,
    DataModelProviderErrorNewsFeedNotFound,
    DataModelProviderErrorNewsItemNotFound,
};

@interface DataModelProvider : NSObject

+ (instancetype) instance;

- (void) getNewsFeedsWithCompletionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock;

- (void)addNewsFeed: (NewsFeed *) newsFeed
    completionBlock: (void (^)(NSError *error))completionBlock;

- (void) removeNewsFeed: (NewsFeed*) newsFeed
        completionBlock: (void (^)(NSError *error))completionBlock;

- (void) updateNewsFeed: (NewsFeed*) NewsFeed
        completionBlock: (void (^)(NSError *error))completionBlock;

-(void) readNewsItem: (NewsItem *) newsItem
            completionBlock: (void (^)(NSError *error))completionBlock;

-(void) changeNewsItemPin: (NewsItem *) newsItem
          completionBlock: (void (^)(NSError *error))completionBlock;

@end
