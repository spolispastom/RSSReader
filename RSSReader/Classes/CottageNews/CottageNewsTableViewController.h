//
//  CottageNewsTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 02.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedList.h"

@interface CottageNewsTableViewController : UITableViewController

@property (nonatomic, setter=setNewsFeedList:) NewsFeedList * newsFeedList;

@end
