//
//  NewsBackgroundDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 04.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsForegroundDownloader.h"

@interface NewsBackgroundDownloader : NSObject<NewsParserDelegate>

- (instancetype) initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                               andURL: (NSURL *) url
                            andParser: (id<NewsParser>) parser;
@end
