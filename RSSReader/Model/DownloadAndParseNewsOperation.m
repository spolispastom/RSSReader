//
//  GettingNewsOperation.m
//  RSSReader
//
//  Created by Михаил Куренков on 22.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "DownloadAndParseNewsOperation.h"
#import "NewsDownloader.h"
#import "RSSParser.h"

@interface DownloadAndParseNewsOperation()

@property NSURL * url;
@property NewsDownloader * downloader;
@property RSSParser * parser;
@property (weak) id<NewsDownloaderDelegate> delegate;

@end

@implementation DownloadAndParseNewsOperation

- (DownloadAndParseNewsOperation *) initWithURL: (NSURL *) url andDelegate: (id<NewsDownloaderDelegate>) delegate
{
    self = [self init];
    
    _url = [url copy];
    _delegate = delegate;
    
    return  self;
}

- (void)main
{
    
    
    _downloader = [[NewsDownloader alloc] initWithDelegate: self
                                                   andURL: _url
                                                andParser: [[RSSParser alloc] init]];
     [_downloader download];
}


- (void)newsDownloader:(NewsDownloader *) downloader didParseNews:(NSArray *)newsItems;
{
    [_delegate newsDownloader: _downloader didParseNews: newsItems];
}


- (void)dealloc
{

}

@end
