//
//  RSSDownloader.m
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsDownloader.h"
#import "NewsParser.h"

@implementation NewsDownloader

- (NewsDownloader *) initWithDelegate: (id<NewsDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (id<NewsParser>) parser{
    self = [super init];
    
    rssDelegate = delegate;
    rssURL = url;
    rssParser = parser;
    rssParser.delegate = self;

    NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
     
    session = [NSURLSession sessionWithConfiguration: defaultConfigObject
                                            delegate: nil
                                       delegateQueue: [NSOperationQueue mainQueue]];
    return self;
}

id<NewsDownloaderDelegate> rssDelegate;
NSURL * rssURL;
NSURLSession * session;

id<NewsParser> rssParser;

- (void) download
{
    
    __weak id<NewsParser> parser = rssParser;
    
    NSURLSessionDataTask * task = [session dataTaskWithURL: rssURL
                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                             
                                             parser.data = data;
                                             [parser parse];
    }];
    
    [task resume];
}


- (void) setNewsArray: (NSArray *) news
{
    [rssDelegate setNewsArray: news];
}

@end
