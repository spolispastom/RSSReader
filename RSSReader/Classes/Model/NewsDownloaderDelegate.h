//
//  RSSDownloaderDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//
@class NewsDownloader;

@protocol NewsDownloaderDelegate <NSObject>

- (void)newsDownloader:(NewsDownloader *) downloader didDownloadNews:(NSArray *)newsItems andTitle: (NSString *) title andImage: (NSData *) image;
- (void)newsDownloader:(NewsDownloader *) downloader didFailDownload:(NSError *) error;

@end