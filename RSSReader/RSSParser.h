//
//  RSSDownloader.h
//  RSSReader
//
//  Created by Михаил Куренков on 19.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItem.h"
#import "RSSParserDelegate.h"

@interface RSSParser : NSObject<NSXMLParserDelegate>

@property (nonatomic) NSData * data;
@property (nonatomic) id<RSSParserDelegate> delegate;

- (BOOL) parse;

@end
