//
//  NewsFeedPersistence.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsItemPersistence;

@interface NewsFeedPersistence : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *newsItems;
@end

@interface NewsFeedPersistence (CoreDataGeneratedAccessors)

- (void)addNewsItemsObject:(NewsItemPersistence *)value;
- (void)removeNewsItemsObject:(NewsItemPersistence *)value;
- (void)addNewsItems:(NSSet *)values;
- (void)removeNewsItems:(NSSet *)values;

@end
