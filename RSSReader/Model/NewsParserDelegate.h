//
//  RSSParserDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 20.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

@protocol NewsParserDelegate <NSObject>

- (void)newsParser:(id) parser didParseNews:(NSArray *)newsItems;

@end