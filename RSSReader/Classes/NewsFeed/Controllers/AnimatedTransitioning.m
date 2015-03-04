//
//  animatedTransitioning.m
//  RSSReader
//
//  Created by Михаил Куренков on 04.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "AnimatedTransitioning.h"

@interface AnimatedTransitioning()
@property (nonatomic) BOOL isBack;
@end

@implementation AnimatedTransitioning

-(instancetype) initWithIsBack: (BOOL) isBack{
    self = [super init];
    _isBack = isBack;
    return  self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGFloat width = toViewController.view.frame.size.width;
    if (_isBack){
        width = -width;
    }
    
    toViewController.view.transform = CGAffineTransformMakeTranslation(width, 0);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation(-width/2, 0);
        toViewController.view.transform = CGAffineTransformMakeTranslation(0, 0);
        
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}
@end
