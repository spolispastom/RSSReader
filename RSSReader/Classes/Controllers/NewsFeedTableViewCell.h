//
//  NewsFeedTableViewCell.h
//  RSSReader
//
//  Created by Михаил Куренков on 10.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *numberOfUnreadNewsLable;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
