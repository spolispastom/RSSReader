//
//  NewsTitleDelegate.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//
@class NewsSourse;
@protocol NewsTitleDelegate <NSObject>

- (void)newsSourse:(NewsSourse *) sourse didParseTitle: (NSString *) title andImage: (NSData *) image;
@end

