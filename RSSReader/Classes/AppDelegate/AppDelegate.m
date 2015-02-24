//
//  AppDelegate.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsFeedTableViewController.h"

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
    
    UINavigationController * navigation = (UINavigationController *)self.window.rootViewController;
    
    _newsFeedList = (NewsFeedTableViewController *)[navigation topViewController];
    
    _sourse = [[NewsFeedList alloc] initWithDelegate: _newsFeedList];
    
    for (NewsFeed * newsFeed in _sourse.newsFeeds)
    {
        [newsFeed downloadAgain];
    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }

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
        [newsFeed backgroundDownloadAgain: self];
        [_notCompletedDownloadNewsSourse addObject:newsFeed];
    }
}

-(void)stopBackgroundFetch{
    for (NewsFeed * newsSourseItem in _notCompletedDownloadNewsSourse) {
        [newsSourseItem cancelDownload];
    }
    [_notCompletedDownloadNewsSourse removeAllObjects];
    [self causeСheckingСompletionHandler];
}

- (void) completeBackgroundDownloadNewsFeed:(NewsFeed *)newsFeed withResult:(UIBackgroundFetchResult)result
{
    if (result == UIBackgroundFetchResultFailed) {
        _isCompleteBackgroundDownloadResultError = YES;
    }
    if (result == UIBackgroundFetchResultNewData) {
        _isCompleteBackgroundDownloadResultNewData = YES;
        
        UILocalNotification* local = [[UILocalNotification alloc]init];
        if (local)
        {
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
