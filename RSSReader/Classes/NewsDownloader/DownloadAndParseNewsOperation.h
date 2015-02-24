//
//  GettingNewsOperation.h
//  RSSReader
//
//  Created by Михаил Куренков on 22.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NewsDownloader.h"

@interface DownloadAndParseNewsOperation : NSOperation <NewsDownloaderDelegate> {
    BOOL        executing;
    BOOL        finished;
}

@property (atomic, copy, readonly) NSArray * newsArray;

- (instancetype) initWithURL: (NSURL *) url
                                    andDelegate: (id<NewsDownloaderDelegate>) delegate;

- (instancetype) initBackgroundDownloadAndParseNewsOperationWithURL: (NSURL *) url
                                                                           andDelegate: (id<NewsDownloaderDelegate>) delegate;

@end
