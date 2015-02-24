//
//  NewsBackgroundDownloader.m
//  RSSReader
//
//  Created by Михаил Куренков on 04.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsBackgroundDownloader.h"
#import "NewsParser.h"

@interface  NewsBackgroundDownloader()

@property (weak, nonatomic) id<NewsDownloaderDelegate> rssDelegate;
@property (nonatomic) NSURL * rssURL;
@property (nonatomic) NSURLSession * session;
@property (nonatomic) NSURLSessionTask * task;

@property (nonatomic) id<NewsParser> rssParser;

@end

@implementation NewsBackgroundDownloader

- (instancetype)initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (id<NewsParser>) parser{
    self = [super init];
    
    _rssDelegate = delegate;
    _rssURL = url;
    _rssParser = parser;
    _rssParser.delegate = self;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    return self;
}

-(NSURL *) url {
    return _rssURL;
}

- (void) download
{
    __weak id<NewsParser> parser = _rssParser;
    
    
    _task = [_session dataTaskWithURL:_rssURL
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (error)
                            [_rssDelegate newsDownloader: (id<NewsDownloader>)self didFailDownload: error];
                        else
                        {
                            parser.data = data;
                            [parser parse];
                        }

                    }];
    
    [_task resume];
}

- (void) cancel
{
    if (_task && _task.state == NSURLSessionTaskStateRunning)
        [_task cancel];
}

- (void)newsParser:(id<NewsParser>)parser didParseNews:(NSArray *)newsItems andTitle:(NSString *)title andImageLink:(NSString *)imageLink
{
    NSData * imageData = nil;
    
    if (imageLink != nil && [imageLink length] > 0)
    {
        NSURL * imageURL = [[NSURL alloc] initWithString:imageLink];
        if (imageURL)
            imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    }
    [_rssDelegate newsDownloader: (id<NewsDownloader>)self didDownloadNews: newsItems andTitle: title andImage: imageData];
}

@end
