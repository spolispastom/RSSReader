//
//  RSSDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 19.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItem.h"
#import "NewsParser.h"
#import "NewsParserDelegate.h"

@interface RSSParser : NSObject<NSXMLParserDelegate, NewsParser>

@property (nonatomic) NSData * data;
@property (nonatomic) id<NewsParserDelegate> delegate;

- (BOOL) parse;

@end
