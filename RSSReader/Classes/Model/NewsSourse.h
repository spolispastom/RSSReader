//
//  NewsSourse.h
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewsSourseDelegate.h"
#import "NewsTitleDelegate.h"
#import "NewsDownloaderDelegate.h"
#import "NewsFeed.h"

@interface NewsSourse : NSObject <NewsDownloaderDelegate>

@property (nonatomic) NSURL * url;
@property (weak, nonatomic, setter=setSourseDelegate:) id<NewsSourseDelegate> sourseDelegate;
@property (weak, nonatomic) id<NewsTitleDelegate> titleDelegate;

- (NewsSourse *) initWithURL: (NewsFeed *) newsFeed andSourseDelegate: (id<NewsSourseDelegate>) sourseDelegate andTitleDelegate: (id<NewsTitleDelegate>) titleDelegate andContext: (NSManagedObjectContext *) context;

- (void)update;

- (void)downloadAgain;

- (int) numberOfUnreadNews;
@end
