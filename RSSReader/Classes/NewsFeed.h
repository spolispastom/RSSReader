//
//  NewsFeed.h
//  RSSReader
//
//  Created by Михаил Куренков on 28.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsItem;

@interface NewsFeed : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *newsItems;
@end

@interface NewsFeed (CoreDataGeneratedAccessors)

- (void)addNewsItemsObject:(NewsItem *)value;
- (void)removeNewsItemsObject:(NewsItem *)value;
- (void)addNewsItems:(NSSet *)values;
- (void)removeNewsItems:(NSSet *)values;

- (NewsFeed *) initWithURL: (NSString *) url ManagedObjectContext:(NSManagedObjectContext *) context;

@end
