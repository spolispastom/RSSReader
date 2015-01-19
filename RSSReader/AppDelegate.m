//
//  AppDelegate.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsItem.h"
#import "RSSListViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NewsItem * item1 = [[ NewsItem alloc ] initWithTitle: @"Китайский производитель смартфонов «вдохновился» моделями Apple и Samsung"
                                         andCreationDate: [NSDate date]
                                              andContent: @"Xiaomi, третий в мире производитель смартфонов, анонсировал модели Mi Note и Mi Note Pro, по дизайну похожие на iPhone 6 Plus. Об этом сообщается в официальном аккаунте компании в Facebook." ];
    
    NewsItem * item2 = [[ NewsItem alloc ] initWithTitle: @"Российские ракетные двигатели разрешили продать в США"
                                         andCreationDate: [NSDate date]
                                              andContent: @"Правительство России выдало разрешение НПО «Энергомаш» и Объединенной ракетно-космической корпорации (ОРКК) на поставку ракетных двигателей РД-181 для ракет-носителей Antares американской корпорации Orbital Sciences. Об этом пишут в пятницу, 16 января, «Известия» со ссылкой на президента ракетно-космической корпорации «Энергия» Владимира Солнцева." ];
    NewsItem * item3 = [[ NewsItem alloc ] initWithTitle: @"Google приостановит производство своих очков"
                                         andCreationDate: [NSDate date]
                                              andContent: @"Компания Google объявила об остановке производства текущей версии Google Glass — очков с прозрачным дисплеем и камерой. Об этом сообщил в четверг, 15 января, телеканал CNBC." ];
    
    UINavigationController * navigation = self.window.rootViewController;
    
    RSSListViewController * RSSList = [navigation topViewController];
  
    RSSList.newsList = @[item1, item2, item3];
    
    return YES;
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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
