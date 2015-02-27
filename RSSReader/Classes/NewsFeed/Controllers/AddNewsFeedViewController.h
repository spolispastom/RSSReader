//
//  AddNewsFeedViewController.h
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsFeed.h"

extern NSString const * AddNewsFeedViewControllerCompliteNotification;

@interface AddNewsFeedViewController : UIViewController

@property NSURL * itemURL;

@end
