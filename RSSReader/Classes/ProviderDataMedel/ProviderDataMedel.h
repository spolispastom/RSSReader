//
//  ProviderDataMedel.h
//  RSSReader
//
//  Created by Михаил Куренков on 17.02.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsFeed.h"

@class ProviderDataMedel;

@protocol ProviderDataMedelDelegate

- (void)providerDataMedelDelegate:(ProviderDataMedel*) provider didNewsFeedCollectionChanget:(NSArray *) newsFeeds;

@end

@interface ProviderDataMedel : NSObject

@property (nonatomic, setter=setDelegate:) id<ProviderDataMedelDelegate> delegate;

+ (ProviderDataMedel *) instance;

- (NSArray*) getNewsFeeds;

- (void) addNewsFeed: (NewsFeed*) newsFeed;
- (void) removeNewsFeed: (NewsFeed*) newsFeed;
- (void) changeNewsFeedFromURL: (NSURL*) url ofTitle: (NSString*) title andImage: (NSData*) image;
- (NewsFeed *) updateNewsFeedFromURL: (NSURL*) url ofTitle: (NSString*) title andImage: (NSData*) image andNewNewsItems: (NSArray *) newsItems;

@end
