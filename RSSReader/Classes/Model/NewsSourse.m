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
        [_sourseDelegate newsSourse:self didParseNews:[[_newsFeed.newsItems allObjects]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NewsItem * item1 = (NewsItem *)obj1;
            NewsItem * item2 = (NewsItem *)obj2;
            if (item1.creationDate > item2.creationDate)
                return NSOrderedDescending;
            else if (item1.creationDate < item2.creationDate)
                return NSOrderedAscending;
            else return NSOrderedSame;
        }]];
    else
        [ self downloadAgain];
}
- (void)newsDownloader:(NewsDownloader *) downloader didDownloadNews:(NSArray *)newsItems andTitle: (NSString *) title andImage: (NSData *) image
{
    for (NewsItem * item in newsItems) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url contains %@", item.url];
        NSSet * oldItems = [_newsFeed.newsItems filteredSetUsingPredicate:predicate];
        if ([oldItems count] == 0)
            [item setValue: _newsFeed forKey:@"newsFeed"];
    }
    
    [self saveContext];
    [self update];
    [_titleDelegate newsSourse:self didParseTitle:title andImage:image];
}

- (void)newsDownloader:(NewsDownloader *) downloader didFailDownload:(NSError *) error
{
    [_sourseDelegate newsSourse: self didFailDownload: error];
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
