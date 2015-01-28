//
//  NewsParser.h
//  RSSReader
//
//  Created by Михаил Куренков on 22.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//
#import "NewsParserDelegate.h"

@protocol NewsParser <NSObject>

@property (nonatomic) NSData * data;
@property (weak, nonatomic) id<NewsParserDelegate> delegate;

- (BOOL) parse;

@end;