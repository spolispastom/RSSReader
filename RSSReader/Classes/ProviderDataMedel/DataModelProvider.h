//
//  ProviderDataMedel.h
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedPersistence.h"
#import "NewsFeed.h"
#import "NewsFeedSerializerPersistence.h"

enum
{
    DataModelProviderErrorAttemptAddExistingNewsFeed,
    DataModelProviderErrorSaving,
};

@interface DataModelProvider : NSObject

+ (instancetype) instance;

- (void) getNewsFeedsWithSerializer: (id<NewsFeedSerializerPersistence>) serializer
                    completionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock;

- (void)addNewsFeedWithURL: (NSString *) url
                  NewsFeed: (NSObject *) newsFeed
            withSerializer: (id<NewsFeedSerializerPersistence>) serializer
           completionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock;

- (void) removeNewsFeedWithURL: (NSString*) newsFeedURL
                withSerializer: (id<NewsFeedSerializerPersistence>) serializer
               completionBlock: (void (^)(NSArray *newsFeeds ,NSError *error))completionBlock;

- (void) updateNewsFeedFromURL: (NSString*) url
                    ofNewsFeed: (NSObject*) NewsFeed
                withSerializer: (id<NewsFeedSerializerPersistence>) serializer
               completionBlock: (void (^)(NSObject *newsFeed ,NSError *error))completionBlock;

-(void) readNewsItemWithURL: (NSString *) url
            completionBlock: (void (^)(NSError *error))completionBlock;

@end
