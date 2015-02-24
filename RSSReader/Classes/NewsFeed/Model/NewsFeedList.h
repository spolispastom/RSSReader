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

@protocol NewsFeedListDelegate <NSObject>

- (void)newsFeedList:(NewsFeedList *) list didGetNewsFeed:(NSArray *)newsFeeds;
- (void)newsFeedList:(NewsFeedList *) sourse;
@end

@interface NewsFeedList : NSObject<NewsTitleDelegate>

@property (weak, nonatomic) id<NewsFeedListDelegate> delegate;

- (NSArray *) newsFeeds;

- (instancetype) initWithDelegate: (id<NewsFeedListDelegate>) delegate;

- (void)addNewsFeed: (NSString *) newsURL;

- (void)removeNewsFeed: (NewsFeed *) newsFeed;

@end
