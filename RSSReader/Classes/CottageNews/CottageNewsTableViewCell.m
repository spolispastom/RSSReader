//
//  CottageNewsTableViewCell.m
//  RSSReader
//
//  Created by Михаил Куренков on 02.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "CottageNewsTableViewCell.h"

@interface CottageNewsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsFeedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDataLable;
@end

@implementation CottageNewsTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL needsLayout = NO;
    
    CGFloat titleLabelWidth = CGRectGetWidth(self.newsTitleLabel.bounds);
    if (self.newsTitleLabel.preferredMaxLayoutWidth != titleLabelWidth) {
        self.newsTitleLabel.preferredMaxLayoutWidth = titleLabelWidth;
        
        needsLayout = YES;
    }
    
    CGFloat newsFeedTitleLabelWidth = CGRectGetWidth(self.newsFeedTitleLabel.bounds);
    if (self.newsFeedTitleLabel.preferredMaxLayoutWidth != newsFeedTitleLabelWidth) {
        self.newsFeedTitleLabel.preferredMaxLayoutWidth = newsFeedTitleLabelWidth;
        
        needsLayout = YES;
    }
    
    CGFloat creationDateLabelWidth = CGRectGetWidth(self.creationDataLable.bounds);
    if (self.creationDataLable.preferredMaxLayoutWidth != creationDateLabelWidth) {
        self.creationDataLable.preferredMaxLayoutWidth = creationDateLabelWidth;
        
        needsLayout = YES;
    }
    
    if (needsLayout) {
        [super layoutSubviews];
    }
}

-(void) setNewsItem: (NewsItem*) newsItem
{
    _newsItem = newsItem;
    
    _newsTitleLabel.text = _newsItem.title;
    if (_newsItem.newsFeed != nil){
        _newsFeedTitleLabel.text = _newsItem.newsFeed.title;
    }
    if (!_defaultDateFormatter)
    {
        _defaultDateFormatter = [[NSDateFormatter alloc] init];
        [_defaultDateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    }
    _creationDataLable.text = [_defaultDateFormatter stringFromDate: _newsItem.creationDate];
    
    if (_newsItem.isRead)
        [self setBackgroundColor:[UIColor clearColor]];
    else [self setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1]];
    

}

@end
