//
//  EntityNewsFeed.h
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EntityNewsFeed : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSSet *newsItems;
@end

@interface EntityNewsFeed (CoreDataGeneratedAccessors)

- (void)addNewsItemsObject:(NSManagedObject *)value;
- (void)removeNewsItemsObject:(NSManagedObject *)value;
- (void)addNewsItems:(NSSet *)values;
- (void)removeNewsItems:(NSSet *)values;

@end
