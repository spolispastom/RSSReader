//
//  NewsItem.m
//  RSSReader
//
//  Created by Михаил Куренков on 30.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsItem.h"
#import "NewsFeed.h"
#import "DataModelProvider.h"

NSString const * NewsItemDidReadNotification = @"NewsItemDidReadNotification";

@implementation NewsItem

- (instancetype) initWithTitle: (NSString*) title andCreationDate: (NSDate*) creationDate andContent: (NSString *) content andUrl: (NSURL*) url andPin: (BOOL) pin{

    self = [super init];
    
    _title = title;
    _creationDate = creationDate;
    _content = content;
    _url = url;
    _isRead = NO;
    _isPin = pin;
    
    return self;
}

- (void) setIsRead: (BOOL) isRead{
    _isRead = isRead;
    if (isRead) {
        [[DataModelProvider instance] updateNewsItem:self completionBlock:^(NSError *error) {
            if (error == nil){
                _isRead = YES;
            }
        }];
    }
    else { _isRead = NO; }
}

-(void) setIsPin: (BOOL) isPin{
    _isPin = isPin;
    [[DataModelProvider instance] updateNewsItem:self completionBlock:^(NSError *error) {
        if (error == nil){
            _isPin = isPin;
        }
    }];
}

@end
