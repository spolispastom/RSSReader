//
//  ShowNewsContentStoryboardSegue.m
//  RSSReader
//
//  Created by Михаил Куренков on 17.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "ShowNewsContentStoryboardSegue.h"
#import "RSSListTableViewController.h"
#import "NewsCintentViewController.h"

@implementation ShowNewsContentStoryboardSegue

- (void)perform {
    RSSListTableViewController * sourceViewController = self.sourceViewController;
    NewsCintentViewController * destinationViewController = self.destinationViewController;
    
    NewsItem * item = sourceViewController.currentNewsItem;
    
    [destinationViewController setCurrentNewsItem: item];
    
  }

@end