//
//  NewsTableViewCell.h
//  RSSReader
//
//  Created by Михаил Куренков on 11.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, setter=setNewsItem:) NewsItem* newsItem;
@property (nonatomic, getter=defaultDateFormatter) NSDateFormatter * defaultDateFormatter;
@end
