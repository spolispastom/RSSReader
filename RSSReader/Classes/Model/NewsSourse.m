//
//  NewsSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsSourse.h"
#import "DownloadAndParseNewsOperation.h"
#import "NewsItem.h"

@interface NewsSourse()

@property (nonatomic, strong, readwrite) NSOperationQueue * queue;
@property (nonatomic, assign, readwrite) BOOL recalculating;
@property (nonatomic, strong, readwrite) DownloadAndParseNewsOperation *   gettingNews;

@property (weak, nonatomic) NSManagedObjectContext * context;

@property (nonatomic) NewsFeed * newsFeed;
@property (nonatomic) NSString * title;

@end

@implementation NewsSourse

- (NewsSourse *) initWithURL: (NewsFeed *) newsFeed andSourseDelegate: (id<NewsSourseDelegate>) sourseDelegate andTitleDelegate: (id<NewsTitleDelegate>) titleDelegate andContext: (NSManagedObjectContext *) context;
{
    self = [super init];
    
    _context = context;
    
    _url = [[NSURL alloc] initWithString: newsFeed.url];
    _sourseDelegate = sourseDelegate;
    _titleDelegate = titleDelegate;
    
    self.queue = [[NSOperationQueue alloc] init];
    assert(self->_queue != nil);
    
    [_sourseDelegate newsSourse:self];
    
    _newsFeed = newsFeed;
    
    return self;
}

- (void) setSourseDelegate: (id<NewsSourseDelegate>) sourseDelegate
{
    _sourseDelegate = sourseDelegate;
    [_sourseDelegate newsSourse:self];
}

- (void)downloadAgain
{
    if (_gettingNews.isReady)
        [_gettingNews cancel];
    self.gettingNews = [[DownloadAndParseNewsOperation alloc] initWithURL: _url andDelegate: self andContext:_context];
    
    [self.queue addOperation: self.gettingNews];
}

- (void)update
{
    if (_newsFeed.newsItems && [_newsFeed.newsItems count] > 0)
        [_sourseDelegate newsSourse:self didParseNews:[_newsFeed.newsItems allObjects]];
    else
        [ self downloadAgain];
}

- (void)newsDownloader:(NewsDownloader *) downloader didDownloadNews:(NSSet *)newsItems andTitle:(NSString *)title
{
    for (NewsItem * item in newsItems) {
        [item setValue: _newsFeed forKey:@"newsFeed"];
    }
    _title = title;
    [self saveContext];
    [self update];
    [_titleDelegate newsSourse:self didParseTitle:title];
}


- (int) numberOfUnreadNews
{
    int count = 0;
    
    for (NewsItem * item in _newsFeed.newsItems) {
        BOOL num = [[item isRead] boolValue];
        if (!num) count++;
    }
    
    return count;
}

- (void)saveContext {
    NSError *error = nil;
    
    if(_context != nil) {
        if([_context hasChanges] && ![_context save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
