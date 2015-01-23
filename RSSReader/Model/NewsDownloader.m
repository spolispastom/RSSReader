//
//  RSSDownloader.m
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsDownloader.h"
#import "NewsParser.h"

@interface  NewsDownloader()

@property (weak, nonatomic) id<NewsDownloaderDelegate> rssDelegate;
@property (nonatomic) NSURL * rssURL;
@property (nonatomic) NSURLSession * session;
@property (nonatomic) NSURLSessionDataTask * task;

@property (nonatomic) id<NewsParser> rssParser;

@end

@implementation NewsDownloader

- (NewsDownloader *)initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (id<NewsParser>) parser{
    self = [super init];
    
    _rssDelegate = delegate;
    _rssURL = url;
    _rssParser = parser;
    _rssParser.delegate = self;

    NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
     
    _session = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                            delegate: nil
                                       delegateQueue: [NSOperationQueue mainQueue]];
    return self;
}

- (void) download
{
    __weak id<NewsParser> parser = _rssParser;
    
     _task = [_session dataTaskWithURL: _rssURL
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       
                       parser.data = data;
                       [parser parse];
                   }];
    
    [_task resume];
}

- (void) cancel
{
    if (_task && _task.state == NSURLSessionTaskStateRunning)
        [_task cancel];
}

- (void)newsParser:(id<NewsParser>)parser didParseNews:(NSArray *)newsItems
{
    [_rssDelegate newsDownloader:self didParseNews: newsItems];
}

@end
