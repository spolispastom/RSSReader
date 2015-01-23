//
//  NewsSourse.h
//  RSSReader
//
//  Created by Михаил Куренков on 23.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsSourseDelegate.h"
#import "NewsDownloaderDelegate.h"

@interface NewsSourse : NSObject <NewsDownloaderDelegate>

@property (nonatomic) NSURL * url;
@property (weak, nonatomic) id<NewsSourseDelegate> delegate;

- (NewsSourse *) initWithURL: (NSURL *) url andDelegate: (id<NewsSourseDelegate>) delegate;

- (void)update;

@end
