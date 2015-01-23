//
//  RSSDownloaderDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

@protocol NewsDownloaderDelegate <NSObject>

- (void)newsDownloader:(id) downloader didParseNews:(NSArray *)newsItems;

@end