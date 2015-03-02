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
NSString const * NewsFeedDidChangeNotificationNumberOfNewNewsKey = @"NewsFeedDidChangeNotificationNumberOfNewNewsKey";

@interface NewsFeed()

@property (nonatomic, strong, readwrite) NSOperationQueue * queue;
@property (nonatomic, assign, readwrite) BOOL recalculating;
@property (nonatomic, strong, readwrite) DownloadAndParseNewsOperation *   gettingNews;
@property (nonatomic) BOOL isBackground;
@property (weak, nonatomic) DataModelProvider * provider;
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

- (void)update
{
    _isBackground = NO;
    if (_gettingNews.isReady)
        [_gettingNews cancel];
    self.gettingNews = [[DownloadAndParseNewsOperation alloc] initWithURL: _url
                                                              andDelegate: self];
    
    [self.queue addOperation: self.gettingNews];
}

- (void)cancelUpdate
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
        NSMutableArray * newNewsItems = [NSMutableArray new];
        NSMutableArray * readingNews = [NSMutableArray new];
        
        for (NewsItem * item in _newsItems) {
            if (item.isRead){
                [readingNews addObject:item.url];
            }
            if (item.isPin){
                [newNewsItems addObject:item];
            }
        }
       
        
        for (NewsItem * item in newsItems) {
            BOOL isContains = NO;
            for (NewsItem * flagItem in newNewsItems) {
                if ([item.url.absoluteString compare:flagItem.url.absoluteString] == NSOrderedSame){
                    isContains = YES;
                }
            }            
            if (!isContains){
                item.newsFeed = self;
                [newNewsItems addObject:item];
            }
            if ([readingNews containsObject:item.url]){
                item.isRead = YES;
            }

        }
        
        [self setNewsItems: newNewsItems];
    }

    [_provider updateNewsFeed:self completionBlock:^(NSError *error) {
        NSMutableDictionary * userInfo = [NSMutableDictionary new];
        [userInfo setObject:[NSNumber numberWithLong:_newsItems.count - newsItems.count] forKey:(NSString*)NewsFeedDidChangeNotificationNumberOfNewNewsKey];
        if (error != nil){
        [userInfo setObject:error forKey:(NSString*)NewsFeedDidChangeNotificationErrorKey];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*) NewsFeedDidChangeNotification object:self userInfo:userInfo];
    }];
}

- (void)newsDownloader:(id<NewsDownloader>) downloader didFailDownload:(NSError *) error
{
    NSMutableDictionary * userInfo = [NSMutableDictionary new];
    [userInfo setObject:error forKey:(NSString*)NewsFeedDidChangeNotificationErrorKey];
        
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*) NewsFeedDidChangeNotification object:self userInfo:userInfo];
}

- (NSInteger) numberOfUnreadNews
{
    NSInteger numberOfUnreadNews = 0;
    for (NewsItem * item in _newsItems) {
        if (!item.isRead) {
            numberOfUnreadNews++;
        }
    }
    return numberOfUnreadNews;
}

@end
