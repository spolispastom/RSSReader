//
//  RSSDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsParser.h"

@class NewsDownloader;

@protocol NewsDownloaderDelegate <NSObject>

- (void)newsDownloader:(NewsDownloader *) downloader didDownloadNews:(NSArray *)newsItems andTitle: (NSString *) title andImage: (NSData *) image;
- (void)newsDownloader:(NewsDownloader *) downloader didFailDownload:(NSError *) error;

@end

@interface NewsDownloader : NSObject<NewsParserDelegate>

@property NSURL * url;

- (NewsDownloader *) initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (id<NewsParser>) parser;

- (void) download;

- (void) cancel;

@end


