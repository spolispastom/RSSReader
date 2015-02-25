//
//  NewsFeedSourse.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeed.h"
#import "NewsFeed.h"
#import "DataModelProvider.h"

@class NewsFeedList;

extern NSString const * NewsFeedListDidChangeNotification;
extern NSString const * NewsFeedListChangeType;

enum NewsFeedListChangeType{
    NewsFeedListChangeTypeAddNewsFeeds,
    NewsFeedListChangeTypeRemoveNewsFeed,
};

@interface NewsFeedList : NSObject

- (instancetype) init;

- (NSArray *) newsFeeds;

- (void)addNewsFeed: (NSString *) newsURL;

- (void)removeNewsFeed: (NewsFeed *) newsFeed;

@end
