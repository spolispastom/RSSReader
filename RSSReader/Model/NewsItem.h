//
//  NewsItem.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property (readonly, nonatomic) NSString * title;
@property (readonly, nonatomic) NSDate * creationDate;
@property (readonly, nonatomic) NSString * content;
@property (readonly, nonatomic) NSString * link;

- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content andLink: (NSString *) link;
- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content;
- (NewsItem *) initWithTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate;

@end
