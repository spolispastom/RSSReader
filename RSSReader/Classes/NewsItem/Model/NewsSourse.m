//
//  NewsSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsSourse.h"
#import "DownloadAndParseNewsOperation.h"
#import "ProviderDataMedel.h"
#import "NewsItem.h"


@interface NewsSourse()

@property (nonatomic, strong, readwrite) NSOperationQueue * queue;
@property (nonatomic, assign, readwrite) BOOL recalculating;
@property (nonatomic, strong, readwrite) DownloadAndParseNewsOperation *   gettingNews;
@property (nonatomic) BOOL isBackground;
@property (weak, nonatomic) id<NewsSourseCompliteBackgroundDownloadDelegate> delegate;
@property (weak, nonatomic) ProviderDataMedel * provider;

@property (nonatomic) NewsFeed * newsFeed;

@end

@implementation NewsSourse

- (NewsSourse *) initWithURL: (NewsFeed *) newsFeed andSourseDelegate: (id<NewsSourseDelegate>) sourseDelegate andTitleDelegate: (id<NewsTitleDelegate>) titleDelegate
{
    self = [super init];
    
    _url = newsFeed.url;
    _sourseDelegate = sourseDelegate;
    _titleDelegate = titleDelegate;
    
    _provider = [ProviderDataMedel instance];
    
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
    _isBackground = NO;
    if (_gettingNews.isReady)
        [_gettingNews cancel];
    self.gettingNews = [[DownloadAndParseNewsOperation alloc] initWithURL: _url
                                                              andDelegate: self];
    
    [self.queue addOperation: self.gettingNews];
}


- (void)backgroundDownloadAgain: (id<NewsSourseCompliteBackgroundDownloadDelegate>) delegate
{
    _delegate = delegate;
    _isBackground = YES;
    if (!_gettingNews.isFinished)
        [_gettingNews cancel];
    self.gettingNews = [[DownloadAndParseNewsOperation alloc] initBackgroundDownloadAndParseNewsOperationWithURL: _url
                                                                                                     andDelegate: self];
    
    [self.queue addOperation: self.gettingNews];
}

- (void)cancelDownload
{
    if (!_gettingNews.isFinished)
        [_gettingNews cancel];
}

- (void)update
{
    if (_newsFeed.newsItems && [_newsFeed.newsItems count] > 0)
        [_sourseDelegate newsSourse:self didParseNews:[_newsFeed.newsItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NewsItem * item1 = (NewsItem *)obj1;
            NewsItem * item2 = (NewsItem *)obj2;
            return  [item2.creationDate compare:item1.creationDate];
        }] andTitle: _newsFeed.title];
    else
        [ self downloadAgain];
}
- (void)newsDownloader:(id<NewsDownloader>) downloader
       didDownloadNews:(NSArray *)newsItems
              andTitle: (NSString *) title
              andImage: (NSData *) image
{
    NSURL * url = [downloader url];
    _newsFeed.newsItems = newsItems;
    NSInteger numberOfNewNews = [_provider updateNewsFeedFromURL:url ofTitle:title andImage:image andNewNewsItems:newsItems];
    
    [self update];
    [_titleDelegate newsSourse:self didParseTitle:title andImage:image];
    
    if (_isBackground && _delegate)
    {
        if (numberOfNewNews > 0) {
            [_delegate completeBackgroundDownloadNewsSourse:self withResult:UIBackgroundFetchResultNewData andTitle:title andNumberOfNewNews:numberOfNewNews];
        } else {
            [_delegate completeBackgroundDownloadNewsSourse:self withResult:UIBackgroundFetchResultNoData andTitle:title andNumberOfNewNews: numberOfNewNews];
        }
    }
}

- (void)newsDownloader:(id<NewsDownloader>) downloader didFailDownload:(NSError *) error
{
    [_sourseDelegate newsSourse: self didFailDownload: error];
    if (_isBackground && _delegate) {
        [_delegate completeBackgroundDownloadNewsSourse:self withResult:UIBackgroundFetchResultFailed andTitle:nil andNumberOfNewNews:0];
    }
}

- (int) numberOfUnreadNews
{
    int count = 0;
    
    for (NewsItem * item in _newsFeed.newsItems) {
        BOOL num = item.isRead;
        if (!num) count++;
    }
    
    return count;
}

/*- (void)saveContext {
    NSError *error = nil;
    
    if(_context != nil) {
        if([_context hasChanges] && ![_context save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}*/

@end
