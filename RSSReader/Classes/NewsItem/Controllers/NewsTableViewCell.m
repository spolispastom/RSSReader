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

-(void) setTitle: (NSString*) title
{
    _titleLabel.text = title;
}

-(void) setCreationData: (NSDate*) creationData
{
    if (!_defaultDateFormatter)
    {
        _defaultDateFormatter = [[NSDateFormatter alloc] init];
        [_defaultDateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    }
    _creationDataLabel.text = [_defaultDateFormatter stringFromDate: creationData];
}


@end
