//
//  RSSListTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"
#import "RSSDownloaderDelegate.h"

@interface RSSListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RSSDownloaderDelegate>

@property (nonatomic, setter=setNewsList:) NSArray * newsList;
@property (nonatomic, getter=defaultDateFormatter) NSDateFormatter * defaultDateFormatter;

@end
