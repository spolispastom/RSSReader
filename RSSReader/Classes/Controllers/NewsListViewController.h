//
//  RSSListTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"
#import "NewsSourse.h"

@interface NewsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NewsSourseDelegate>

@property (nonatomic, setter=setNewsList:) NSArray * newsList;
@property (nonatomic) NSString * newsFeedTitle;
@property (nonatomic, getter=defaultDateFormatter) NSDateFormatter * defaultDateFormatter;

@end
