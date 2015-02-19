//
//  ProviderDataMedel.m
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "ProviderDataMedel.h"
#import "EntityNewsFeed.h"
#import "EntityNewsItem.h"
#import "NewsFeed.h"
#import "NewsItem.h"

@interface ProviderDataMedel()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ProviderDataMedel

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton

static ProviderDataMedel *sharedProviderDataMedel_ = nil;

+ (ProviderDataMedel *) instance
{
    if (sharedProviderDataMedel_ == nil)
    {
        sharedProviderDataMedel_ = [[ProviderDataMedel alloc] init];
    }
    return sharedProviderDataMedel_;
}

- (id) copy
{
    return self;
}

#pragma mark - CoreDate

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil){
        return _managedObjectModel;
    }
    
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"NewsFeedsDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationsDocumentsDirectory] URLByAppendingPathComponent:@"RSSReader.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext != nil){
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSURL *)applicationsDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext {
    NSError *error = nil;
    
    if([self managedObjectContext] != nil) {
        if([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - the provider functions

- (void)setDelegate: (id<ProviderDataMedelDelegate>) delegate {
    _delegate = delegate;
    [_delegate providerDataMedelDelegate:self didNewsFeedCollectionChanget:[self getNewsFeeds]];
}

- (NSArray*) getNewsFeeds {
    __block NSMutableArray * newsFeeds = [[NSMutableArray alloc]init];
    
    NSManagedObjectContext * context = [self managedObjectContext];
    [context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityNewsFeed" inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
    
        NSArray * entityNewsFeeds = [[self managedObjectContext] executeFetchRequest:request error:nil];
    
        for (EntityNewsFeed * entityNewsFeed in entityNewsFeeds) {
            NewsFeed * newsFeed = [[NewsFeed alloc]initWithTitle:entityNewsFeed.title
                                                      andURL:[NSURL URLWithString:entityNewsFeed.link]
                                                    andImage:entityNewsFeed.image];
        
            NSMutableSet * newsItems = [[NSMutableSet alloc]init];
            for (EntityNewsItem * entityItem in entityNewsFeed.newsItems) {
                NewsItem * newsItem = [[NewsItem alloc]initWithTitle:entityItem.title
                                                 andCreationDate:entityItem.creationDate
                                                      andContent:entityItem.content
                                                          andUrl:[NSURL URLWithString:entityItem.link]];
                newsItem.isRead = [entityItem.isRead boolValue];
                [newsItems addObject:newsItem];
            }
            newsFeed.newsItems = [newsItems allObjects];
            [newsFeeds addObject:newsFeed];
        }
    }];
    return newsFeeds;
}

- (void) addNewsFeed: (NewsFeed*) newsFeed {
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlock:^{
        
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityNewsFeed" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", newsFeed.url];
        [request setPredicate:predicate];
        
        NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
        
        if (resultNewsFeeds.count == 0)
        {
            EntityNewsFeed * item = [EntityNewsFeed alloc];
            item = [NSEntityDescription insertNewObjectForEntityForName:@"EntityNewsFeed" inManagedObjectContext: context];
    
            item.title = newsFeed.title;
            item.link = newsFeed.url.absoluteString;
        
            [context save:&error];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate providerDataMedelDelegate:self didNewsFeedCollectionChanget:[self getNewsFeeds]];
            });
        }
    }];
}

- (void) removeNewsFeed: (NewsFeed*) newsFeed {
    
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlock:^{
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityNewsFeed" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", newsFeed.url];
        [request setPredicate:predicate];
        
        NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
        
        for (EntityNewsFeed * item in resultNewsFeeds) {
            [context deleteObject: item];
        }
        [context save:&error];
    } ];
    
    /*NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityNewsFeed" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", newsFeed.url];
    [request setPredicate:predicate];
    
    NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];

    for (EntityNewsFeed * item in resultNewsFeeds) {
        
        [context deleteObject: item];
    }
    [self saveContext];*/
}

- (NewsFeed *) updateNewsFeedFromURL: (NSURL*) url ofTitle: (NSString*) title andImage: (NSData*) image andNewNewsItems: (NSArray *) newsItems
{
    __block NewsFeed * retNewsFeed = [[NewsFeed alloc]init];
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"EntityNewsFeed" inManagedObjectContext:context];
        [request setEntity:entity];
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", url];
        [request setPredicate:predicate];
    
        NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
    
        if (resultNewsFeeds.count != 0)
        {
            EntityNewsFeed * entityNewsFeed = resultNewsFeeds.firstObject;
            entityNewsFeed.title = title;
            entityNewsFeed.image = image;
        
            if (newsItems != nil) {
                for (NewsItem * item in newsItems) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains %@", item.title];
                    NSSet * oldItems = [entityNewsFeed.newsItems filteredSetUsingPredicate:predicate];
                    if ([oldItems count] == 0)
                    {
                        EntityNewsItem * entityNewsItem = [NSEntityDescription insertNewObjectForEntityForName:@"EntityNewsItem" inManagedObjectContext: [self managedObjectContext]];
                    
                        entityNewsItem.title = item.title;
                        entityNewsItem.link = item.url.absoluteString;
                        entityNewsItem.creationDate = item.creationDate;
                        entityNewsItem.content = item.content;
                        entityNewsItem.isRead = [NSNumber numberWithBool:item.isRead];
                        
                        [entityNewsItem setValue: entityNewsFeed forKey:@"newsFeed"];
                        [entityNewsFeed addNewsItemsObject:entityNewsItem];
                    }
                    else 
                    {
                        EntityNewsItem * eNewsItem = [oldItems anyObject];
                        eNewsItem.title = item.title;
                        eNewsItem.link = item.url.absoluteString;
                        eNewsItem.creationDate = item.creationDate;
                        eNewsItem.content = item.content;
                        if (item.isRead){
                            eNewsItem.isRead = [NSNumber numberWithBool: item.isRead];
                        }
                    }
                }
            }
            
            
            [context save:&error];
            
            retNewsFeed.title = entityNewsFeed.title;
            retNewsFeed.url = url;
            retNewsFeed.imageData = entityNewsFeed.image;
            NSMutableArray * retNewsItems = [NSMutableArray new];
            for (EntityNewsItem * eNewsItem in entityNewsFeed.newsItems) {
                NewsItem * item = [[NewsItem alloc]initWithTitle:eNewsItem.title
                                                 andCreationDate:eNewsItem.creationDate
                                                      andContent:eNewsItem.content
                                                          andUrl:[NSURL URLWithString: eNewsItem.link]];
                BOOL isread = [eNewsItem.isRead boolValue];
                item.isRead = isread;
                
                [retNewsItems addObject:item];
            }
            retNewsFeed.newsItems = retNewsItems;
        }
    }];
    return  retNewsFeed;
}


- (void) changeNewsFeedFromURL: (NSURL*) url ofTitle: (NSString*) title andImage: (NSData*) image {
    [self updateNewsFeedFromURL:url ofTitle:title andImage:image andNewNewsItems:nil];
}


#pragma mark -
@end
