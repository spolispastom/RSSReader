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

extern NSString const * NewsItemDidReadNotification;

@interface NewsItem : NSObject 

@property (nonatomic) NSString * content;
@property (nonatomic) NSDate * creationDate;
@property (nonatomic, setter=setIsRead:) BOOL isRead;
@property (nonatomic, setter=setIsPin:) BOOL isPin;
@property (nonatomic) NSString * title;
@property (nonatomic) NSURL * url;
@property (weak, nonatomic) NewsFeed* newsFeed;
@property (nonatomic, copy) NSString *persistenceId;

- (instancetype) initWithTitle: (NSString*) title andCreationDate: (NSDate*) creationDate andContent: (NSString *) content andUrl: (NSURL*) url;

@end
