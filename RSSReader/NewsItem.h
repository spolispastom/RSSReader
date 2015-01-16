//
//  NewsItem.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItem : NSObject

@property NSString * Title;
@property (readonly) NSDate * CreationDate ;
@property NSString * Content;

- (NewsItem *) initFromTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate andContent: (NSString *) content;
- (NewsItem *) initFromTitle: (NSString * ) title andCreationDate: (NSDate *) creationDate;

@end
