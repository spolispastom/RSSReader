//
//  GettingNewsOperation.h
//  RSSReader
//
//  Created by Михаил Куренков on 22.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewsDownloaderDelegate.h"

@interface DownloadAndParseNewsOperation : NSOperation <NewsDownloaderDelegate>

@property (atomic, copy, readonly) NSArray * newsArray;

- (DownloadAndParseNewsOperation *) initWithURL: (NSURL *) url andDelegate: (id<NewsDownloaderDelegate>) delegate andContext: (NSManagedObjectContext *) context;

@end