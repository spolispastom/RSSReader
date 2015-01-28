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

- (RSSParser *) initWithData: (NSData *) data andContext: (NSManagedObjectContext *) context;
- (RSSParser *) initWithContext: (NSManagedObjectContext *) context;

- (BOOL) parse;

@end
