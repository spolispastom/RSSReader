//
//  NewsFeed.m
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeed.h"
#import "NewsItem.h"
#import "DownloadAndParseNewsOperation.h"
#import "DataModelProvider.h"

NSString const * NewsFeedDidChangeNotification = @"NewsFeedDidChangeNotification";
NSString const * NewsFeedDidChangeNotificationErrorKey = @"NewsFeedDidChangeNotificationErrorKey";

@interface NewsFeed()

@property (nonatomic, strong, readwrite) NSOperationQueue * queue;
@property (nonatomic, assign, readwrite) BOOL recalculating;
@property (nonatomic, strong, readwrite) DownloadAndParseNewsOperation *   gettingNews;
@property (nonatomic) BOOL isBackground;
@property (weak, nonatomic) id<NewsFeedCompliteBackgroundDownloadDelegate> delegate;
@property (weak, nonatomic) DataModelProvider * provider;
@property (nonatomic) NSInteger oldNumberOfUnreadNews;
@end

@implementation NewsFeed

- (instancetype) initWithTitle: (NSString *) title andURL: (NSURL*) url andImage: (NSData *) imageData
{
    self = [super init];
    
    _title = title;
    _url = url;
    _image = [UIImage imageWithData: imageData];
    _newsItems = nil;
    
    _provider = [DataModelProvider instance];
    
    self.queue = [[NSOperationQueue alloc] init];
    
    return self;
}

- (void) setNewsItems: (NSArray *) newsItems {
    _newsItems = [newsItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NewsItem * item1 = (NewsItem *)obj1;
        NewsItem * item2 = (NewsItem *)obj2;
        return [item2.creationDate compare:item1.creationDate];
    }];
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


- (void)backgroundDownloadAgain: (id<NewsFeedCompliteBackgroundDownloadDelegate>) delegate
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


- (void)newsDownloader:(id<NewsDownloader>) downloader
       didDownloadNews:(NSArray *)newsItems
              andTitle: (NSString *) title
              andImage: (NSData *) image
{
    _url = [downloader url];
    _title = title;
    _image = [UIImage imageWithData: image];
    
    if (newsItems != nil) {
        NSMutableArray * readingNews = [NSMutableArray new];
        
        for (NewsItem * item in _newsItems) {
            if (item.isRead){
                [readingNews addObject:item.url];
            }
        }
        
        for (NewsItem * item in newsItems) {
            if ([readingNews containsObject:item.url]){
                item.isRead = YES;
            }
        }
        
        [self setNewsItems: newsItems];
    }

    [_provider updateNewsFeed:self completionBlock:^(NSError *error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*) NewsFeedDidChangeNotification object:self];
        
        if (_isBackground && _delegate)
        {
            NSInteger numberOfNewNews = _newsItems.count - newsItems.count;
            if (numberOfNewNews > 0) {
            [_delegate completeBackgroundDownloadNewsFeed:self withResult: UIBackgroundFetchResultNewData];
            } else {
                [_delegate completeBackgroundDownloadNewsFeed:self withResult:UIBackgroundFetchResultNoData];
            }
        }
    }];
}

- (void)newsDownloader:(id<NewsDownloader>) downloader didFailDownload:(NSError *) error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*) NewsFeedDidChangeNotification
                                                        object:self
                                                      userInfo:@{(NSString*)NewsFeedDidChangeNotificationErrorKey:error}];
    
    if (_isBackground && _delegate) {
        [_delegate completeBackgroundDownloadNewsFeed:self withResult:UIBackgroundFetchResultFailed];
    }
}

- (NSInteger) numberOfUnreadNews
{
    NSMutableArray * changetNewsItems = [NSMutableArray new];
    
    for (NewsItem * item in _newsItems) {
        if (item.isRead) {
            [changetNewsItems addObject:item];
        }
    }
    
    NSInteger numberOfUnreadNews = _newsItems.count - changetNewsItems.count;
    
    
    /*if (_oldNumberOfUnreadNews != numberOfUnreadNews && _oldNumberOfUnreadNews != -1){
        _newsFeed = [_provider updateNewsFeedFromURL:_newsFeed.url ofTitle:_newsFeed.title andImage:_newsFeed.imageData andNewNewsItems:changetNewsItems];
    }*/
    
    _oldNumberOfUnreadNews = numberOfUnreadNews;
    return numberOfUnreadNews;
}

- (void) readNewsItem: (NewsItem*) newsItem{
    __block NewsItem * blockNewsItem = newsItem;
    [_provider readNewsItem:newsItem completionBlock:^(NSError *error) {
        if (error == nil){
        blockNewsItem.isRead = YES;
        }
    }];
}

@end
