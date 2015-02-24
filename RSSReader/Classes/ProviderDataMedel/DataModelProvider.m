//
//  ProviderDataMedel.m
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "DataModelProvider.h"
#import "NewsItemPersistence.h"

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

- (void) getNewsFeedsWithSerializer: (id<NewsFeedSerializerPersistence>) serializer
                    completionBlock: (void (^)(NSArray *newsFeeds, NSError *error))completionBlock {
    __block NSMutableArray * newsFeeds = [[NSMutableArray alloc]init];
    
    NSManagedObjectContext * context = [self managedObjectContext];
    [context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeedPersistence" inManagedObjectContext:[self managedObjectContext]];
        [request setEntity:entity];
        
        NSArray * entityNewsFeeds = [[self managedObjectContext] executeFetchRequest:request error:nil];
        
        for (NewsFeedPersistence * entityNewsFeed in entityNewsFeeds) {
            NSObject * newsFeed = [serializer deserialise:entityNewsFeed];
           
            [newsFeeds addObject:newsFeed];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak NSMutableArray * weakNewsFeeds = newsFeeds;
            completionBlock(weakNewsFeeds, nil);
        });
    }];

}

- (void)addNewsFeedWithURL: (NSString *) url
                  NewsFeed: (NSObject *) newsFeed
            withSerializer: (id<NewsFeedSerializerPersistence>) serializer
           completionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock;{
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlock:^{
        
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeedPersistence" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", url];
        [request setPredicate:predicate];
        
        NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
        
        if (resultNewsFeeds.count == 0) {
            [serializer serialize:newsFeed inContext:context];
            
            [context save:&error];
            
            if (error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(nil, [[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                                   code:DataModelProviderErrorSaving
                                                               userInfo:error.userInfo]);});
            } else {
                [self getNewsFeedsWithSerializer:serializer completionBlock:completionBlock];
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, [[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                               code:DataModelProviderErrorAttemptAddExistingNewsFeed
                                                           userInfo:nil]);
            });
        }
    }];
}

- (void) removeNewsFeedWithURL: (NSString*) newsFeedURL
                withSerializer: (id<NewsFeedSerializerPersistence>) serializer
               completionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock{
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlock:^{
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeedPersistence" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", newsFeedURL];
        [request setPredicate:predicate];
        
        NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
        
        for (NewsFeedPersistence * item in resultNewsFeeds) {
            [context deleteObject: item];
        }
        [context save:&error];
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, [[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                               code:DataModelProviderErrorSaving
                                                           userInfo:error.userInfo]);});
        } else {
            [self getNewsFeedsWithSerializer:serializer completionBlock:completionBlock];
        }
    } ];
}


- (void) updateNewsFeedFromURL: (NSString*) url
                    ofNewsFeed: (NSObject*) NewsFeed
                withSerializer: (id<NewsFeedSerializerPersistence>) serializer
               completionBlock: (void (^)(NSObject *newsFeed ,NSError *error))completionBlock{
  
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeedPersistence" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", url];
        [request setPredicate:predicate];
        
        NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
        
        if (resultNewsFeeds.count != 0)
        {
            [serializer serialize:NewsFeed atPersistenceNewsFeed:resultNewsFeeds.firstObject inContext:context];
        }
        
        [context save:&error];
            
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, [[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                                code:DataModelProviderErrorSaving
                                                            userInfo:error.userInfo]);});
        } else {
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeedPersistence" inManagedObjectContext:context];
            [request setEntity:entity];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", url];
            [request setPredicate:predicate];
            
            NSArray * resultNewsFeeds = [context executeFetchRequest:request error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([serializer deserialise: resultNewsFeeds.firstObject], nil);
            });
        }
    }];
}

-(void) readNewsItemWithURL: (NSString *) url
            completionBlock: (void (^)(NSError *error))completionBlock{
    
    __block NSError *error = nil;
    NSManagedObjectContext * context = [self managedObjectContext];
    [ context performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsItemPersistence" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"link contains %@", url];
        [request setPredicate:predicate];
        
        NSArray * resultNewsItems = [context executeFetchRequest:request error:nil];
        
        if (resultNewsItems.count != 0)
        {
            for (NewsItemPersistence *item in resultNewsItems) {
                item.isRead = [NSNumber numberWithBool:YES];
            }
        }
        
        [context save:&error];
        
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock([[NSError alloc]initWithDomain:@"DataModelProviderError"
                                                               code:DataModelProviderErrorSaving
                                                           userInfo:nil]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil);
            });
        }
    }];

    
}

#pragma mark -
@end
