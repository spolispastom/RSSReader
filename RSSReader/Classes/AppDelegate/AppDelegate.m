//
//  AppDelegate.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsFeedTableViewController.h"
#import "CottageNewsTableViewController.h"

@interface AppDelegate ()

@property (weak, nonatomic) NewsFeedTableViewController * newsFeedList;
@property (nonatomic) NewsFeedList * sourse;

@property (nonatomic) BOOL isCompleteBackgroundDownloadResultNewData;
@property (nonatomic) BOOL isCompleteBackgroundDownloadResultError;
@property (nonatomic) NSMutableArray* notCompletedDownloadNewsSourse;

@property (copy, nonatomic) void(^ backgroundFetchCompletionHandler)(UIBackgroundFetchResult result);
@property (nonatomic) UIBackgroundTaskIdentifier taskIdForBackgroundFetch;
@property (nonatomic) BOOL isRuningFetch;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    NSTimeInterval interval = UIApplicationBackgroundFetchIntervalMinimum;
    [application setMinimumBackgroundFetchInterval: interval];
    
    UITabBarController * mainTabBarController = (UITabBarController *)self.window.rootViewController;
    
    UINavigationController * navigation = (UINavigationController *)mainTabBarController.viewControllers[0];
    
    _newsFeedList = (NewsFeedTableViewController *)[navigation topViewController];
    
    _sourse = [[NewsFeedList alloc] init];
    
    _newsFeedList.newsFeedList = _sourse;
    
    for (NewsFeed * newsFeed in _sourse.newsFeeds)
    {
        [newsFeed update];
    }
    
    //CottageNewsTableViewController * cottageNewsTable = (CottageNewsTableViewController *)mainTabBarController.viewControllers[1];
    
    UINavigationController * cottageNewsTableNavigation = (UINavigationController *)mainTabBarController.viewControllers[1];
    
    CottageNewsTableViewController * cottageNewsTable = (CottageNewsTableViewController *)[cottageNewsTableNavigation topViewController];
    
    cottageNewsTable.newsFeedList = _sourse;
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    _window.tintColor = [UIColor blueColor];
    _window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    if (_isRuningFetch){
        [self stopBackgroundFetch];
    }
    _isRuningFetch = YES;
    _backgroundFetchCompletionHandler = completionHandler;
    
    _taskIdForBackgroundFetch = [application beginBackgroundTaskWithExpirationHandler:^{
        [self stopBackgroundFetch];
    }];
    
    if (!_notCompletedDownloadNewsSourse){
        _notCompletedDownloadNewsSourse = [[NSMutableArray alloc] init];
    }
    
    _isCompleteBackgroundDownloadResultNewData = NO;
    _isCompleteBackgroundDownloadResultError = NO;
    for (NewsFeed * newsFeed in _sourse.newsFeeds)
    {
         __block id<NSObject> newsFeedChangeObserver = [[NSNotificationCenter defaultCenter]addObserverForName:(NSString*)NewsFeedDidChangeNotification object:newsFeed queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
             NSError * error = [note.userInfo objectForKey:(NSString*)NewsFeedDidChangeNotificationErrorKey];
             NSNumber * numberOfNewNews = [note.userInfo objectForKey:(NSString*)NewsFeedDidChangeNotificationNumberOfNewNewsKey];
             
             if (error != nil){
                 _isCompleteBackgroundDownloadResultError = YES;
             } else if (numberOfNewNews > 0){
                 _isCompleteBackgroundDownloadResultNewData = YES;
             
                 UILocalNotification* local = [[UILocalNotification alloc]init];
                 if (local){
                     local.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
                     local.alertBody = [NSString stringWithFormat:@"У вас %ld новых новостей в ленте %@",
                                       (long)newsFeed.numberOfUnreadNews,
                                       newsFeed.title];
                     local.alertAction = newsFeed.url.absoluteString;
                     local.timeZone = [NSTimeZone defaultTimeZone];
                    
                     [[UIApplication sharedApplication] scheduleLocalNotification:local];
                 }
             }
            
             [_notCompletedDownloadNewsSourse removeObject:newsFeed];
            
             [self causeСheckingСompletionHandler];
             
             [[NSNotificationCenter defaultCenter] removeObserver: newsFeedChangeObserver];
        }];
        [newsFeed update];
        [_notCompletedDownloadNewsSourse addObject:newsFeed];
    }
}

-(void)stopBackgroundFetch{
    for (NewsFeed * newsSourseItem in _notCompletedDownloadNewsSourse) {
        [newsSourseItem cancelUpdate];
    }
    [_notCompletedDownloadNewsSourse removeAllObjects];
    [self causeСheckingСompletionHandler];
}

-(void)causeСheckingСompletionHandler
{
    if (_notCompletedDownloadNewsSourse.count == 0) {
        [[UIApplication sharedApplication] endBackgroundTask:_taskIdForBackgroundFetch];
        
        if (_isCompleteBackgroundDownloadResultNewData) {
            _backgroundFetchCompletionHandler(UIBackgroundFetchResultNewData);
        } else if (_isCompleteBackgroundDownloadResultError) {
            _backgroundFetchCompletionHandler(UIBackgroundFetchResultFailed);
        } else {
            _backgroundFetchCompletionHandler(UIBackgroundFetchResultNoData);
        }
        _isRuningFetch = NO;
    }
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    NSURL * url = [NSURL URLWithString: notification.alertAction];
    [_newsFeedList showNewsItemFromURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //
    //_iconBadgeNumber = 0;
    //for (NewsFeed * newsFeed in _sourse.newsFeeds) {
    //    _iconBadgeNumber += [[_sourse getNewsSourseFromNewsFeed:newsFeed] numberOfUnreadNews];
    //}
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
