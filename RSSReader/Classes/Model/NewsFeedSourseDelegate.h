//
//  NewsFeedSourseDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//
@class NewsFeedSourse;
@protocol NewsFeedSourseDelegate <NSObject>

- (void)newsSourse:(NewsFeedSourse *) sourse didGetNewsFeed:(NSArray *)newsFeeds;
- (void)newsSourse:(NewsFeedSourse *) sourse;
@end
