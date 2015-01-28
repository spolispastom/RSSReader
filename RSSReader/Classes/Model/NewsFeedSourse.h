//
//  NewsFeedSourse.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedSourseDelegate.h"
#import "NewsFeed.h"
#import "NewsSourse.h"

@interface NewsFeedSourse : NSObject<NewsTitleDelegate>

@property (weak, nonatomic) id<NewsFeedSourseDelegate> delegate;

- (NSArray *) newsFeeds;

- (NewsFeedSourse *) initWithDelegate: (id<NewsFeedSourseDelegate>) delegate andContext: (NSManagedObjectContext *) context;

- (void)addNewsFeed: (NSString *) newsURL;

- (void)removeNewsFeed: (NewsFeed *) newsFeed;

- (NewsSourse *) getNewsSourseFromNewsFeed: (NewsFeed *) newsFeed;

- (void)saveContext;

@end
