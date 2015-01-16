//
//  RSSListTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsItem.h"

@interface RSSListTableViewController : UITableViewController

@property NSMutableArray * NewsItems;
@property NewsItem * currentNewsItem;

- (IBAction) unwindToList: (UIStoryboardSegue *) segue ;

@end
