//
//  SelectionContext.h
//  RSSReader
//
//  Created by Михаил Куренков on 17.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItem.h"


@interface SelectionContext : NSObject

@property NewsItem * SelectionNews;

+ (SelectionContext * ) Instance;

@end


