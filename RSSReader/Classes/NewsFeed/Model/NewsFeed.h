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

extern NSString const * NewsFeedDidChangeNotification;
extern NSString const * NewsFeedDidChangeNotificationErrorKey;
extern NSString const * NewsFeedDidChangeNotificationNumberOfNewNewsKey;

@interface NewsFeed : NSObject<NewsDownloaderDelegate>

@property (nonatomic) NSString * title;
@property (nonatomic) NSURL * url;
@property (nonatomic) UIImage * image;
@property (nonatomic, setter=setNewsItems:) NSArray *newsItems;
@property (nonatomic, copy) NSString *persistenceId;
@property (nonatomic, readonly, getter=numberOfUnreadNews) NSInteger numberOfUnreadNews;

- (instancetype) initWithTitle: (NSString *) title andURL: (NSURL*) url andImage: (NSData *) imageData;

- (void)update;

- (void)cancelUpdate;

@end

