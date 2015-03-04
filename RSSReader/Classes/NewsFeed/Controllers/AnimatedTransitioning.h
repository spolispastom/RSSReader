//
//  animatedTransitioning.h
//  RSSReader
//
//  Created by Михаил Куренков on 04.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
    -(instancetype) initWithIsBack: (BOOL) isBack;
@end