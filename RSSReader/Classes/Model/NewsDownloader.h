//
//  NewsDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 04.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

@protocol NewsDownloader

@property NSURL * url;

- (void) download;
- (void) cancel;

@end

@protocol NewsDownloaderDelegate <NSObject>

- (void)newsDownloader:(id<NewsDownloader>) downloader didDownloadNews:(NSArray *)newsItems andTitle: (NSString *) title andImage: (NSData *) image;
- (void)newsDownloader:(id<NewsDownloader>) downloader didFailDownload:(NSError *) error;

@end