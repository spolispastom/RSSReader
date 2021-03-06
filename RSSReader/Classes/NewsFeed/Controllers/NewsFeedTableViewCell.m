//
//  NewsFeedTableViewCell.m
//  RSSReader
//
//  Created by Михаил Куренков on 10.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedTableViewCell.h"

@interface NewsFeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *numberOfUnreadNewsLable;
@property (weak, nonatomic, readonly) IBOutlet UIImageView* imageView;

@end

@implementation NewsFeedTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _numberOfUnreadNewsLable.adjustsFontSizeToFitWidth = YES;
    
    BOOL needsLayout = NO;
    
    CGFloat titleLabelWidth = CGRectGetWidth(self.titleLable.bounds);
    if (self.titleLable.preferredMaxLayoutWidth != titleLabelWidth) {
        self.titleLable.preferredMaxLayoutWidth = titleLabelWidth;
        
        needsLayout = YES;
    }

    if (needsLayout) {
        [super layoutSubviews];
        
    }
}

-(void) setTitle: (NSString*) title {
    _titleLable.text = title;
}

-(void) setNumberOfUnreadNews: (NSInteger) numberOfUnreadNews {
    _numberOfUnreadNewsLable.text = [NSString stringWithFormat: @"%ld", (long)numberOfUnreadNews];
}

-(void) setImage: (UIImage*) image {
    UIImage * uiImage = image;
    
    if (image == nil){
        uiImage = [UIImage imageNamed:@"rss"];
    }
    
    CGImageRef imgRef = [uiImage CGImage];
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGSize size = CGSizeMake(width, height);
        
    if (height < width) {
        size.width = 60;
        size.height = 65 * height / width;
    }
    else {
        size.width = 65 * width / height;
        size.height = 65;
    }
    
    UIGraphicsBeginImageContext(size);
    
    [uiImage drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
        
    [self imageView].image = imageCopy;
}

@end
