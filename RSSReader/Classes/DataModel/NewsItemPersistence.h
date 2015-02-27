//
//  NewsItemPersistence.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsFeedPersistence;

@interface NewsItemPersistence : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * pin;
@property (nonatomic, retain) NewsFeedPersistence *newsFeed;

@end
