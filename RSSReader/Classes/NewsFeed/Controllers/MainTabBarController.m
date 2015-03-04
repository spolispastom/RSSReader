//
//  MainTabBarController.m
//  RSSReader
//
//  Created by Михаил Куренков on 04.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "MainTabBarController.h"
#import "AnimatedTransitioning.h"
#import "NewsFeedTableViewController.h"

@class animatedTransitioning;

@interface MainTabBarController ()

@end

@implementation MainTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {

    UINavigationController* navigation = (UINavigationController*)toVC;
    BOOL isBack = [navigation.topViewController isKindOfClass:[NewsFeedTableViewController class]];
    return [[AnimatedTransitioning alloc] initWithIsBack:isBack];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

