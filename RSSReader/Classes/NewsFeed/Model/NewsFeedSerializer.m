//
//  NewsFeedSerializer.m
//  RSSReader
//
//  Created by Михаил Куренков on 24.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedSerializer.h"
#import <Foundation/Foundation.h>
#import "NewsFeedPersistence.h"
#import "NewsItemPersistence.h"
#import "NewsFeed.h"
#import "NewsItem.h"

@implementation NewsFeedSerializer


- (NewsFeedPersistence *) serialize: (NSObject *) object inContext: (NSManagedObjectContext *) context
{
    NewsFeed * newsFeed = (NewsFeed *)object;
    NewsFeedPersistence * item = [NewsFeedPersistence alloc];
    item = [NSEntityDescription insertNewObjectForEntityForName:@"NewsFeedPersistence" inManagedObjectContext: context];
    
    item.title = newsFeed.title;
    item.link = newsFeed.url.absoluteString;
    
    for (NewsItem * newsItem in newsFeed.newsItems) {
        NewsItemPersistence * entityNewsItem = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItemPersistence" inManagedObjectContext: context];
        
        entityNewsItem.title = newsItem.title;
        entityNewsItem.link = newsItem.url.absoluteString;
        entityNewsItem.creationDate = newsItem.creationDate;
        entityNewsItem.content = newsItem.content;
        entityNewsItem.isRead = [NSNumber numberWithBool:newsItem.isRead];
        
        [entityNewsItem setValue: item forKey:@"newsFeed"];
        [item addNewsItemsObject:entityNewsItem];
    }
    
    return item;
}

- (NewsFeedPersistence *) serialize: (NSObject *) object atPersistenceNewsFeed: (NewsFeedPersistence *) persistenceNewsFeed  inContext: (NSManagedObjectContext *) context
{
    NewsFeed * newsFeed = (NewsFeed *)object;
    
    persistenceNewsFeed.title = newsFeed.title;
    persistenceNewsFeed.image = newsFeed.imageData;
    
    if (newsFeed.newsItems != nil) {
        NSMutableArray * readingNews = [NSMutableArray new];
        
        for (NewsItemPersistence * item in persistenceNewsFeed.newsItems) {
            if ([item.isRead boolValue]){
                [readingNews addObject:item.link];
            }
        }
        
        [persistenceNewsFeed removeNewsItems:persistenceNewsFeed.newsItems];
        
        for (NewsItem * item in newsFeed.newsItems) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@", item.title];
            NSSet * oldItems = [persistenceNewsFeed.newsItems filteredSetUsingPredicate:predicate];
            if ([oldItems count] == 0)
            {
                NewsItemPersistence * entityNewsItem = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItemPersistence" inManagedObjectContext: context];
                
                entityNewsItem.title = item.title;
                entityNewsItem.link = item.url.absoluteString;
                entityNewsItem.creationDate = item.creationDate;
                entityNewsItem.content = item.content;
                if ([readingNews containsObject:item.url.absoluteString]){
                    entityNewsItem.isRead = [NSNumber numberWithBool:YES];
                } else {
                    entityNewsItem.isRead = [NSNumber numberWithBool:item.isRead];
                }
                [entityNewsItem setValue: persistenceNewsFeed forKey:@"newsFeed"];
                [persistenceNewsFeed addNewsItemsObject:entityNewsItem];
            }
        }
    /*    for (NewsItem * item in newsFeed.newsItems) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@", item.title];
            NSSet * oldItems = [persistenceNewsFeed.newsItems filteredSetUsingPredicate:predicate];
            if ([oldItems count] == 0)
            {
                NewsItemPersistence * entityNewsItem = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItemPersistence" inManagedObjectContext: context];
                
                entityNewsItem.title = item.title;
                entityNewsItem.link = item.url.absoluteString;
                entityNewsItem.creationDate = item.creationDate;
                entityNewsItem.content = item.content;
                entityNewsItem.isRead = [NSNumber numberWithBool:item.isRead];
                
                [entityNewsItem setValue: persistenceNewsFeed forKey:@"newsFeed"];
                [persistenceNewsFeed addNewsItemsObject:entityNewsItem];
            }
            else
            {
                NewsItemPersistence * eNewsItem = [oldItems anyObject];
                eNewsItem.title = item.title;
                eNewsItem.link = item.url.absoluteString;
                eNewsItem.creationDate = item.creationDate;
                eNewsItem.content = item.content;
                if (item.isRead){
                    eNewsItem.isRead = [NSNumber numberWithBool: item.isRead];
                }
            }
        }*/
    }

    
    return persistenceNewsFeed;
}

- (NSObject *) deserialise: (NewsFeedPersistence *) entityNewsFeed
{
    NewsFeed * newsFeed = [[NewsFeed alloc]initWithTitle:entityNewsFeed.title
                                                  andURL:[NSURL URLWithString:entityNewsFeed.link]
                                                andImage:entityNewsFeed.image];
    
    NSMutableSet * newsItems = [[NSMutableSet alloc]init];
    for (NewsItemPersistence * entityItem in entityNewsFeed.newsItems) {
        NewsItem * newsItem = [[NewsItem alloc]initWithTitle:entityItem.title
                                             andCreationDate:entityItem.creationDate
                                                  andContent:entityItem.content
                                                      andUrl:[NSURL URLWithString:entityItem.link]];
        newsItem.isRead = [entityItem.isRead boolValue];
        [newsItems addObject:newsItem];
    }
    newsFeed.newsItems = [newsItems allObjects];
    
    
    return newsFeed;
}

@end
