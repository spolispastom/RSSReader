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

@property (weak, nonatomic) NSManagedObjectContext * context;

@end

@implementation DownloadAndParseNewsOperation

- (DownloadAndParseNewsOperation *) initWithURL: (NSURL *) url andDelegate: (id<NewsDownloaderDelegate>) delegate andContext: (NSManagedObjectContext *) context
{
    self = [self init];
    
    _context = context;
    
    _url = [url copy];
    _delegate = delegate;
    
    return  self;
}

- (void)main
{
    _downloader = [[NewsDownloader alloc] initWithDelegate: self
                                                   andURL: _url
                                                andParser: [[RSSParser alloc] initWithContext:_context]];
     [_downloader download];
}


- (void)newsDownloader:(NewsDownloader *) downloader didDownloadNews:(NSArray *)newsItems andTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
       [_delegate newsDownloader: _downloader didDownloadNews: newsItems andTitle: title];
    });
}


- (void)dealloc
{

}

@end
