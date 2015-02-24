//
//  NewsFeed.h
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "NewsForegroundDownloader.h"

@class NewsItem;
@class NewsFeed;

@protocol NewsTitleDelegate <NSObject>
- (void)NewsFeed:(NewsFeed *) sourse didParseTitle: (NSString *) title andImage: (NSData *) image;
@end

@protocol NewsFeedDelegate <NSObject>
- (void)NewsFeed:(NewsFeed *) newsFeed;
- (void)NewsFeed:(NewsFeed *) newsFeed didUpdateNews:(NSArray *)newsItems;
- (void)NewsFeed:(NewsFeed *) newsFeed didFailDownload:(NSError *) error;
@end

@protocol NewsFeedCompliteBackgroundDownloadDelegate
- (void) completeBackgroundDownloadNewsFeed: (NewsFeed*) newsFeed
                                 withResult: (UIBackgroundFetchResult) result;
@end

@interface NewsFeed : NSObject <NewsDownloaderDelegate>

@property (nonatomic) NSString * title;
@property (nonatomic) NSURL * url;
@property (nonatomic) NSData * imageData;
@property (nonatomic) NSArray *newsItems;

@property (weak, nonatomic, setter=setNewsFeedDelegate:) id<NewsFeedDelegate> newsFeedDelegate;
@property (weak, nonatomic) id<NewsTitleDelegate> titleDelegate;

- (instancetype) initWithTitle: (NSString *) title andURL: (NSURL*) url andImage: (NSData *) imageData;

- (void)update;

- (void)downloadAgain;

- (void)backgroundDownloadAgain: (id<NewsFeedCompliteBackgroundDownloadDelegate>) delegate;

- (void)cancelDownload;

- (NSInteger) numberOfUnreadNews;

- (void) readNewsItem: (NewsItem*) newsItem;

@end

