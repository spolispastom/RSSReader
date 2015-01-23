//
//  RSSDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsDownloaderDelegate.h"
#import "NewsParserDelegate.h"
#import "NewsParser.h"


@interface NewsDownloader : NSObject<NewsParserDelegate>

@property NSURL * url;

- (NewsDownloader *) initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (id<NewsParser>) parser;

- (void) download;

- (void) cancel;

- (void)newsParser:(id<NewsParser>)parser didParseNews:(NSArray *)newsItems;

@end


