//
//  NewsFeedTableViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeedList.h"

@interface NewsFeedTableViewController : UITableViewController <NewsFeedListDelegate>

@property (nonatomic) NSArray * newsFeedList;

- (IBAction)unwindToNewsFeedTable:(UIStoryboardSegue *)segue;
- (void) showNewsItemFromURL: (NSURL*) url;

@end
