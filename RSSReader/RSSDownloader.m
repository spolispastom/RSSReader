//
//  RSSDownloader.m
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "RSSDownloader.h"
#import "RSSParser.h"

@implementation RSSDownloader

- (RSSDownloader *) initWithDelegate: (id<RSSDownloaderDelegate>) delegate
                              andURL: (NSURL *) url
                           andParser: (RSSParser *) parser{
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

id<RSSDownloaderDelegate> rssDelegate;
NSURL * rssURL;
NSURLSession * session;

RSSParser * rssParser;

- (void) download
{
    
    __weak RSSParser * parser = rssParser;
    
    NSURLSessionDataTask * task = [session dataTaskWithURL: rssURL
                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                             
                                             parser.data = data;
                                             [parser parse];
    }];
    
    [task resume];
}


- (void) setNewsArray: (NSArray *) news
{
    rssDelegate.newsList = news;
}

@end
