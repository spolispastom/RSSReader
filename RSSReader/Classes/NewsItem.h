//
//  NewsItem.h
//  RSSReader
//
//  Created by Михаил Куренков on 28.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsFeed;

@interface NewsItem : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NewsFeed *newsFeed;

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content andLink: (NSString *) link
                  andContext:(NSManagedObjectContext *) context;
- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content
                  andContext:(NSManagedObjectContext *) context;
- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContext:(NSManagedObjectContext *) context;

@end
