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

extern NSString const * NewsFeedListAddNewsFeedNotification;
extern NSString const * NewsFeedListAddNewsFeedFailNotification;
extern NSString const * NewsFeedListRemoveNewsFeedNotification;
extern NSString const * NewsFeedTitleKey;

@interface NewsFeedList : NSObject

- (instancetype) init;

- (NSArray *) newsFeeds;

- (void)addNewsFeed: (NSURL *) newsURL;

- (void)removeNewsFeed: (NewsFeed *) newsFeed;

@end
