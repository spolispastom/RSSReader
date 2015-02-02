//
//  RSSParserDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//
@protocol NewsParser;

@protocol NewsParserDelegate <NSObject>

- (void)newsParser:(id<NewsParser>) parser didParseNews:(NSArray *)newsItems andTitle: (NSString *) title andImageLink: (NSString *) imageLink;

@end