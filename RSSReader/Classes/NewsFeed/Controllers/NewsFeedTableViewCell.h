//
//  NewsFeedTableViewCell.h
//  RSSReader
//
//  Created by Михаил Куренков on 10.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewCell : UITableViewCell

@property (nonatomic, setter=setTitle:) NSString *title;
@property (nonatomic, setter=setNumberOfUnreadNews:) NSInteger numberOfUnreadNews;
@property (nonatomic, setter=setImage:) NSData *image;

@end
