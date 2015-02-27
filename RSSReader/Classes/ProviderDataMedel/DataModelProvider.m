//
//  ProviderDataMedel.m
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "DataModelProvider.h"
#import "NewsItemPersistence.h"

NSString const * DataModelProviderError = @"DataModelProviderError";

@interface DataModelProvider()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DataModelProvider

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton

static DataModelProvider *sharedProviderDataMedel_ = nil;

+ (instancetype) instance
{
    if (sharedProviderDataMedel_ == nil)
    {
        sharedProviderDataMedel_ = [[DataModelProvider alloc] init];
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

- (void) getNewsFeedsWithCompletionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock{
    NSParameterAssert(completionBlock);
    
    NSManagedObjectContext * context = [self managedObjectContext];
    [context performBlockAndWait:^{
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeedPersistence" inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
        
        NSArray * entityNewsFeeds = [context executeFetchRequest:request error:nil];
    
        NSMutableArray * newsFeeds = [[NSMutableArray alloc]init];
        
        for (NewsFeedPersistence * entityNewsFeed in entityNewsFeeds) {
            NewsFeed * newsFeed = [[NewsFeed alloc]initWithTitle:entityNewsFeed.title
                                                          andURL:[NSURL URLWithString: entityNewsFeed.link]
                                                        andImage:entityNewsFeed.image];
            
            newsFeed.persistenceId = entityNewsFeed.objectID.URIRepresentation.absoluteString;
            
            NSMutableSet * newsItems = [[NSMutableSet alloc]init];
            for (NewsItemPersistence * entityItem in entityNewsFeed.newsItems) {
                NewsItem * newsItem = [[NewsItem alloc]initWithTitle:entityItem.title
                                                     andCreationDate:entityItem.creationDate
                                                          andContent:entityItem.content
                                                              andUrl:[NSURL URLWithString:entityItem.link]];
                
                newsItem.persistenceId = entityItem.objectID.URIRepresentation.absoluteString;
                
                newsItem.isRead = [entityItem.isRead boolValue];
                newsItem.isPin = [entityItem.pin boolValue];
                [newsItems addObject:newsItem];
            }
            newsFeed.newsItems = [newsItems allObjects];
            
            [newsFeeds addObject:newsFeed];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak NSMutableArray * weakNewsFeeds = newsFeeds;
            completionBlock(weakNewsFeeds, nil);
        });
    }];
}

- (void)addNewsFeed: (NewsFeed *) newsFeed
    completionBlock: (void (^)(NSError *error))completionBlock{
    NSManagedObjectContext * context = [self managedObjectContext];
    [context performBlock:^{
        NSError *error = nil;
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
            entityNewsItem.pin = [NSNumber numberWithBool:newsItem.isPin];
            
            [entityNewsItem setValue: item forKey:@"newsFeed"];
            [item addNewsItemsObject:entityNewsItem];
        }
            
        [context save:&error];
        
        [self updateObjectIdInNewsFeed:newsFeed fromNewsFeedPersistence:item];
        
        if (completionBlock != nil)
        {
            if (error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                              code:DataModelProviderErrorSaving
                                                          userInfo:error.userInfo]);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil);
                });
            }
        }
    }];
}
     
- (void) removeNewsFeed: (NewsFeed*) newsFeed
        completionBlock: (void (^)(NSError *error))completionBlock{
    if (newsFeed == nil){
        return;
    }
    
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlock:^{
        NSError *error = nil;
        
        NSURL *persistentUTI = [NSURL URLWithString:newsFeed.persistenceId];
        if (persistentUTI != nil){
            NSManagedObjectID *objectId = [_persistentStoreCoordinator managedObjectIDForURIRepresentation:persistentUTI];
            if(objectId != nil) {
                NewsFeedPersistence * item = (NewsFeedPersistence*)[context objectWithID:objectId];
                if (item != nil){
                    [context deleteObject: item];
                    
                    [context save:&error];
                    
                    [self updateObjectIdInNewsFeed:newsFeed fromNewsFeedPersistence:item];
                    
                    if (completionBlock != nil)
                    {
                        if (error){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                                          code:DataModelProviderErrorSaving
                                                                      userInfo:error.userInfo]);
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completionBlock(nil);
                            });
                        }
                    }
                }
            }
        }
    } ];
}

- (void) updateNewsFeed: (NewsFeed*) newsFeed
        completionBlock: (void (^)(NSError *error))completionBlock{
    if (newsFeed == nil){
        return;
    }
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlockAndWait:^{
        NSError *error = nil;
        
        NSURL *persistentUTI = [NSURL URLWithString:newsFeed.persistenceId];
        if (persistentUTI != nil){
            NSManagedObjectID *objectId = [_persistentStoreCoordinator managedObjectIDForURIRepresentation:persistentUTI];
            if(objectId != nil) {
                NewsFeedPersistence * persistenceNewsFeed = (NewsFeedPersistence*)[context objectWithID:objectId];
                
                persistenceNewsFeed.title = newsFeed.title;
                NSData * image = UIImagePNGRepresentation(newsFeed.image);
                persistenceNewsFeed.image = image;
                
                if (newsFeed.newsItems != nil) {
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
                            entityNewsItem.isRead = [NSNumber numberWithBool:item.isRead];
                            entityNewsItem.pin = [NSNumber numberWithBool:item.isPin];
                            
                            [entityNewsItem setValue: persistenceNewsFeed forKey:@"newsFeed"];
                            [persistenceNewsFeed addNewsItemsObject:entityNewsItem];
                        }
                    }
                }
                   
                [context save:&error];
                
                [self updateObjectIdInNewsFeed:newsFeed fromNewsFeedPersistence:persistenceNewsFeed];
                
                if (completionBlock != nil){
                    if (error){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                                      code:DataModelProviderErrorSaving
                                                                  userInfo:error.userInfo]);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil);
                        });
                    }
                }
            } else if (completionBlock != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                              code:DataModelProviderErrorNewsFeedNotFound
                                                          userInfo:nil]);
                });
            }
        }
    } ];
}

-(void) readNewsItem: (NewsItem *) newsItem
     completionBlock: (void (^)(NSError *error))completionBlock{
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlockAndWait:^{
        NSError *error = nil;
        
        NSURL *persistentUTI = [NSURL URLWithString:newsItem.persistenceId];
        if (persistentUTI != nil){
            NSManagedObjectID *objectId = [_persistentStoreCoordinator managedObjectIDForURIRepresentation:persistentUTI];
            if(objectId != nil) {
                NewsItemPersistence * persistenceNewsItem = (NewsItemPersistence*)[context objectWithID:objectId];
                persistenceNewsItem.isRead = [NSNumber numberWithBool:YES];
                
                [context save:&error];
                
                newsItem.persistenceId = persistenceNewsItem.objectID.URIRepresentation.absoluteString;
                
                if (completionBlock != nil){
                    if (error){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                                      code:DataModelProviderErrorSaving
                                                                  userInfo:error.userInfo]);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil);
                        });
                    }
                }
            } else if (completionBlock != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                              code:DataModelProviderErrorNewsFeedNotFound
                                                          userInfo:nil]);
                });
            }
        }
    }];
    
}

-(void) changeNewsItemPin: (NewsItem *) newsItem
      completionBlock: (void (^)(NSError *error))completionBlock{
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlockAndWait:^{
        NSError *error = nil;
        
        NSURL *persistentUTI = [NSURL URLWithString:newsItem.persistenceId];
        if (persistentUTI != nil){
            NSManagedObjectID *objectId = [_persistentStoreCoordinator managedObjectIDForURIRepresentation:persistentUTI];
            if(objectId != nil) {
                NewsItemPersistence * persistenceNewsItem = (NewsItemPersistence*)[context objectWithID:objectId];
                persistenceNewsItem.pin = [NSNumber numberWithBool:newsItem.isPin];
                
                [context save:&error];
                
                newsItem.persistenceId = persistenceNewsItem.objectID.URIRepresentation.absoluteString;
                
                if (completionBlock != nil){
                    if (error){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                                      code:DataModelProviderErrorSaving
                                                                  userInfo:error.userInfo]);
                        });
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionBlock(nil);
                        });
                    }
                }
            } else if (completionBlock != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                              code:DataModelProviderErrorNewsFeedNotFound
                                                          userInfo:nil]);
                });
            }
        }
    }];
    
}

-(void) updateObjectIdInNewsFeed: (NewsFeed*) newsFeed fromNewsFeedPersistence: (NewsFeedPersistence*) newsFeedPersistence{
    newsFeed.persistenceId = newsFeedPersistence.objectID.URIRepresentation.absoluteString;
    
    for (NewsItem * newsItem in newsFeed.newsItems) {
        for (NewsItemPersistence * newsItemPersistence in newsFeedPersistence.newsItems) {
            newsItem.persistenceId = newsItemPersistence.objectID.URIRepresentation.absoluteString;
        }
    }
}

#pragma mark -
@end
