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
#import "NewsForegroundDownloader.h"
#import "NewsBackgroundDownloader.h"

@interface DownloadAndParseNewsOperation()

@property NSURL * url;
@property id<NewsDownloader> downloader;
@property RSSParser * parser;
@property (weak) id<NewsDownloaderDelegate> delegate;

@property (nonatomic) BOOL isBackground;

@end

@implementation DownloadAndParseNewsOperation

- (DownloadAndParseNewsOperation *) initWithURL: (NSURL *) url
                                    andDelegate: (id<NewsDownloaderDelegate>) delegate
{
    self = [self init];
    
    if (self) {
        executing = NO;
        finished = NO;
    
        _url = [url copy];
        _delegate = delegate;
    }
    
    _isBackground = NO;
    return  self;
}


- (DownloadAndParseNewsOperation *) initBackgroundDownloadAndParseNewsOperationWithURL: (NSURL *) url
                                                                           andDelegate: (id<NewsDownloaderDelegate>) delegate
{
    self = [self initWithURL:url andDelegate:delegate];
    
    _isBackground = YES;
    
    return  self;
}

- (BOOL) isAsynchronous
{
    return YES;
}
 
- (void)start
{
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{
    if (_isBackground)
    {
        _downloader = (id<NewsDownloader>)[[NewsBackgroundDownloader alloc] initWithDelegate: self
                                                         andURL: _url
                                                      andParser: [[RSSParser alloc] init]];
    }
    else
    {
        _downloader = (id<NewsDownloader>)[[NewsForegroundDownloader alloc] initWithDelegate: self
                                                   andURL: _url
                                                andParser: [[RSSParser alloc] init]];
    }
    [_downloader download];
}

- (void)newsDownloader:(id<NewsDownloader>) downloader didDownloadNews:(NSArray *)newsItems andTitle: (NSString *) title andImage: (NSData *) image
{
    dispatch_async(dispatch_get_main_queue(), ^{
       [_delegate newsDownloader: _downloader didDownloadNews: newsItems andTitle: title andImage:image];
    });
    [self completeOperation];
}

- (void)cancel
{
    [_downloader cancel];
    [self completeOperation];
}

- (BOOL) isExecuting
{
    return executing;
}

- (BOOL) isFinished
{
    return finished;
}

- (BOOL) isConcurrent
{
    return YES;
}

- (void)newsDownloader:(id<NewsDownloader>) downloader didFailDownload:(NSError *) error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate newsDownloader: (id<NewsDownloader>)self didFailDownload: error];
    });
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

@end
