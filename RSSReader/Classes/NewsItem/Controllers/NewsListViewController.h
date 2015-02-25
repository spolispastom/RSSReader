//
//  RSSListTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"
#import "NewsFeed.h"

@interface NewsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, setter=setNewsFeed:) NewsFeed* newsFeed;

@end
