//
//  NewsTableViewCell.m
//  RSSReader
//
//  Created by Михаил Куренков on 11.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDataLabel;
@property (weak, nonatomic) IBOutlet UIButton *pinButton;

@end

@implementation NewsTableViewCell

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL needsLayout = NO;
    
    CGFloat titleLabelWidth = CGRectGetWidth(self.titleLabel.bounds);
    if (self.titleLabel.preferredMaxLayoutWidth != titleLabelWidth) {
        self.titleLabel.preferredMaxLayoutWidth = titleLabelWidth;
        
        needsLayout = YES;
    }
    
    CGFloat creationDateLabelWidth = CGRectGetWidth(self.creationDataLabel.bounds);
    if (self.creationDataLabel.preferredMaxLayoutWidth != creationDateLabelWidth) {
        self.creationDataLabel.preferredMaxLayoutWidth = creationDateLabelWidth;
        
        needsLayout = YES;
    }

    if (needsLayout) {
        [super layoutSubviews];
    }
}

-(void) setNewsItem: (NewsItem*) newsItem
{
    _newsItem = newsItem;
    
    _titleLabel.text = _newsItem.title;

    if (!_defaultDateFormatter)
    {
        _defaultDateFormatter = [[NSDateFormatter alloc] init];
        [_defaultDateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    }
    _creationDataLabel.text = [_defaultDateFormatter stringFromDate: _newsItem.creationDate];

    if (_newsItem.isRead)
        [self setBackgroundColor:[UIColor clearColor]];
    else [self setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1]];
    
    [self updatePinButton];
}
- (IBAction)pinTouchDoun:(id)sender {
    _newsItem.isPin = !_newsItem.isPin;
    
    [self updatePinButton];
}

-(void) updatePinButton{
    _pinButton.selected = _newsItem.isPin;
}

@end
