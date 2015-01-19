//
//  RSSListTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface RSSListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (setter=setNewsList:) NSArray * newsList;
@property (getter=defaultDateFormatter) NSDateFormatter * defaultDateFormatter;

@end
