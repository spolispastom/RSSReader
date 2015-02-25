//
//  NewsItem.h
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsFeed;

@interface NewsItem : NSObject 

@property (nonatomic) NSString * content;
@property (nonatomic) NSDate * creationDate;
@property (nonatomic, setter=setIsRead:) BOOL isRead;
@property (nonatomic) NSString * title;
@property (nonatomic) NSURL * url;

- (instancetype) initWithTitle: (NSString*) title andCreationDate: (NSDate*) creationDate andContent: (NSString *) content andUrl: (NSURL*) url;

@end
