//
//  RSSDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsParser.h"
#import "NewsDownloader.h"

@interface NewsForegroundDownloader : NSObject<NewsParserDelegate>

- (instancetype) initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (id<NewsParser>) parser;


@end


