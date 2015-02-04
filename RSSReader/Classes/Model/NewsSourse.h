//
//  NewsSourse.h
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewsFeed.h"
#import "NewsSourse.h"
#import "NewsDownloader.h"

@class NewsSourse;
@protocol NewsSourseDelegate <NSObject>

- (void)newsSourse:(NewsSourse *) sourse didParseNews:(NSArray *)newsItems;
- (void)newsSourse:(NewsSourse *) sourse;
- (void)newsSourse:(NewsSourse *) sourse didFailDownload:(NSError *) error;
@end

@protocol NewsTitleDelegate <NSObject>

- (void)newsSourse:(NewsSourse *) sourse didParseTitle: (NSString *) title andImage: (NSData *) image;
@end

@interface NewsSourse : NSObject <NewsDownloaderDelegate>

@property (nonatomic) NSURL * url;
@property (weak, nonatomic, setter=setSourseDelegate:) id<NewsSourseDelegate> sourseDelegate;
@property (weak, nonatomic) id<NewsTitleDelegate> titleDelegate;

- (NewsSourse *) initWithURL: (NewsFeed *) newsFeed andSourseDelegate: (id<NewsSourseDelegate>) sourseDelegate andTitleDelegate: (id<NewsTitleDelegate>) titleDelegate andContext: (NSManagedObjectContext *) context;

- (void)update;

- (void)downloadAgain;

- (int) numberOfUnreadNews;
@end
