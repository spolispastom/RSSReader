//
//  CottageNewsTableViewCell.h
//  RSSReader
//
//  Created by Михаил Куренков on 02.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"
#import "NewsFeed.h"

@interface CottageNewsTableViewCell : UITableViewCell

@property (nonatomic, setter=setNewsItem:) NewsItem* newsItem;
@property (nonatomic, getter=defaultDateFormatter) NSDateFormatter * defaultDateFormatter;

@end
