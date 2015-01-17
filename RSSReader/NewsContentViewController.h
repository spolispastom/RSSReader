//
//  NewsCintentViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSListTableViewController.h"
#import "NewsItem.h"

@interface NewsContentViewController : UIViewController

- (void) setCurrentNewsItem: (NewsItem *) item;

- (NewsContentViewController *) init;

@end
