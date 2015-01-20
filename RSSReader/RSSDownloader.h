//
//  RSSDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSDownloaderDelegate.h"
#import "RSSParserDelegate.h"
#import "RSSParser.h"


@interface RSSDownloader : NSObject<RSSParserDelegate>

@property NSURL * url;

- (RSSDownloader *) initWithDelegate: (id<RSSDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (RSSParser *) parser;

- (void) download;

- (void) setNewsArray: (NSArray *) news;

@end


