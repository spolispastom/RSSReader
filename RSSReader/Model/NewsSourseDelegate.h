//
//  NewsSourseDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//
@class NewsSourse;
@protocol NewsSourseDelegate <NSObject>

- (void)newsSourse:(NewsSourse *) sourse didParseNews:(NSArray *)newsItems;
- (void)newsSourse:(NewsSourse *) sourse;
@end
