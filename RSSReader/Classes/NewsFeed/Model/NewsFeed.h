//
//  NewsFeed.h
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsItem;

@interface NewsFeed : NSObject 

@property (nonatomic) NSString * title;
@property (nonatomic) NSURL * url;
@property (nonatomic) NSData * imageData;
@property (nonatomic) NSArray *newsItems;

- (NewsFeed *) initWithTitle: (NSString *) title andURL: (NSURL*) url andImage: (NSData *) imageData;

@end

