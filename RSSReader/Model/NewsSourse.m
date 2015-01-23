//
//  NewsSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsSourse.h"
#import "DownloadAndParseNewsOperation.h"

@interface NewsSourse()

@property (nonatomic, strong, readwrite) NSOperationQueue * queue;
@property (nonatomic, assign, readwrite) BOOL recalculating;
@property (nonatomic, strong, readwrite) DownloadAndParseNewsOperation *   gettingNews;

@end

@implementation NewsSourse

- (NewsSourse *) initWithURL: (NSURL *) url andDelegate: (id<NewsSourseDelegate>) delegate
{
    self = [super init];
    
    _url = url;
    _delegate = delegate;
    
    self.queue = [[NSOperationQueue alloc] init];
    assert(self->_queue != nil);
    
    [_delegate newsSourse:self];
    
    return self;
}

- (void)update
{
    if (_gettingNews.isReady)
        [_gettingNews cancel];
    self.gettingNews = [[DownloadAndParseNewsOperation alloc] initWithURL: _url andDelegate: self];
    
    [self.queue addOperation: self.gettingNews];
}

- (void)newsDownloader:(NewsDownloader *) downloader didParseNews:(NSArray *)newsItems
{
    [_delegate newsSourse:self didParseNews:newsItems];
}

@end
