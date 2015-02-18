//
//  NewsFeedSourse.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeed.h"
#import "NewsSourse.h"
#import "ProviderDataMedel.h"

@class NewsFeedSourse;

@protocol NewsFeedSourseDelegate <NSObject>

- (void)newsSourse:(NewsFeedSourse *) sourse didGetNewsFeed:(NSArray *)newsFeeds;
- (void)newsSourse:(NewsFeedSourse *) sourse;
@end

@interface NewsFeedSourse : NSObject<NewsTitleDelegate, ProviderDataMedelDelegate>

@property (weak, nonatomic) id<NewsFeedSourseDelegate> delegate;

- (NSArray *) newsFeeds;

- (NewsFeedSourse *) initWithDelegate: (id<NewsFeedSourseDelegate>) delegate;

- (void)addNewsFeed: (NSString *) newsURL;

- (void)removeNewsFeed: (NewsFeed *) newsFeed;

- (NewsSourse *) getNewsSourseFromNewsFeed: (NewsFeed *) newsFeed;

@end
