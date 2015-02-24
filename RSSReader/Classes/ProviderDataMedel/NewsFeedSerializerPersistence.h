//
//  persistenceNewsFeedSerializer.h
//  RSSReader
//
//  Created by Михаил Куренков on 24.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeedPersistence.h"

@protocol NewsFeedSerializerPersistence <NSObject>

- (NewsFeedPersistence *) serialize: (NSObject *) object inContext: (NSManagedObjectContext *) context;
- (NewsFeedPersistence *) serialize: (NSObject *) object atPersistenceNewsFeed: (NewsFeedPersistence *) persistenceNewsFeed  inContext: (NSManagedObjectContext *) context;
- (NSObject *) deserialise: (NewsFeedPersistence *) entityNewsFeed;

@end
