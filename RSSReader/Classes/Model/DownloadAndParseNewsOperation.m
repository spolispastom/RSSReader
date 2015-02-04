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
    
    if (self) {
        executing = NO;
        finished = NO;
    
        _context = context;
    
        _url = [url copy];
        _delegate = delegate;
    }
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
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main
{
    _downloader = [[NewsDownloader alloc] initWithDelegate: self
                                                   andURL: _url
                                                andParser: [[RSSParser alloc] initWithContext:_context]];
     [_downloader download];
}

- (void)newsDownloader:(NewsDownloader *) downloader didDownloadNews:(NSArray *)newsItems andTitle: (NSString *) title andImage: (NSData *) image
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

- (void)newsDownloader:(NewsDownloader *) downloader didFailDownload:(NSError *) error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate newsDownloader: (NewsDownloader *)self didFailDownload: error];
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
