//
//  TitleLabel.m
//  RSSReader
//
//  Created by Михаил Куренков on 11.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "TitleLabel.h"

@implementation TitleLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}
@end
