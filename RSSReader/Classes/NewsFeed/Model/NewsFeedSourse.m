//
//  NewsFeedSourse.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedSourse.h"

@interface NewsFeedSourse()

@property (nonatomic) NSMutableDictionary * newsSourses;
@property (weak, nonatomic) NSManagedObjectContext * context;

@end

@implementation NewsFeedSourse

- (NewsFeedSourse *) initWithDelegate: (id<NewsFeedSourseDelegate>) delegate andContext: (NSManagedObjectContext *) context
{
    self = [super init];
    
    _context = context;
    
    
    _delegate = delegate;
    [_delegate newsSourse: self didGetNewsFeed: [self newsFeeds]];
    
    _newsSourses = [[NSMutableDictionary alloc] init];
    
    return  self;
}

- (NSArray *) newsFeeds
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeed" inManagedObjectContext:_context];
    [request setEntity:entity];
    
    return [[_context executeFetchRequest:request error:nil] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NewsFeed * item1 = (NewsFeed *)obj1;
        NewsFeed * item2 = (NewsFeed *)obj2;
        if (item1.title > item2.title)
            return NSOrderedDescending;
        else if (item1.title < item2.title)
            return NSOrderedAscending;
        else return NSOrderedSame;
    }];
}

- (void)addNewsFeed: (NSString *) newsFeed
{
    NewsFeed * item = [NewsFeed alloc];
    item = [NSEntityDescription insertNewObjectForEntityForName:@"NewsFeed" inManagedObjectContext: _context];
    
    item.title = newsFeed;
    item.url = newsFeed;
    
    [self saveContext];
    
    NewsSourse * newsSourse = [[NewsSourse alloc] initWithURL:item
                                            andSourseDelegate:nil
                                             andTitleDelegate:self
                                                   andContext:_context];
    [_newsSourses setObject:newsSourse forKey: item.url];
    
    [_delegate newsSourse:self didGetNewsFeed: [self newsFeeds]];
}

- (void)removeNewsFeed: (NewsFeed *) newsFeed
{
    [_newsSourses removeObjectForKey:newsFeed.url];
    [_context deleteObject: newsFeed];
    [self saveContext];
    
    [_delegate newsSourse:self didGetNewsFeed:[self newsFeeds]];
}

- (NewsSourse *) getNewsSourseFromNewsFeed: (NewsFeed *) newsFeed;
{
    NewsSourse * sourse = [_newsSourses objectForKey:newsFeed.url];
    
    if (!sourse)
    {
        sourse = [[NewsSourse alloc] initWithURL:newsFeed
                               andSourseDelegate:nil
                                andTitleDelegate:self
                                      andContext:_context];
        [_newsSourses setObject: sourse forKey: newsFeed.url];
        
    }
    return sourse;
}

- (void)newsSourse:(NewsSourse *) sourse didParseTitle: (NSString *) title andImage:(NSData *)image
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"NewsFeed" inManagedObjectContext:_context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url contains %@", sourse.url];
    [request setPredicate:predicate];
    
    NSArray * resultNewsFeeds = [_context executeFetchRequest:request error:nil];
    
    for (NewsFeed * newsFeed in resultNewsFeeds) {
        newsFeed.title = title;
        newsFeed.image = image;
    }
    
    [_delegate newsSourse:self didGetNewsFeed:[self newsFeeds]];
}

- (void)saveContext {
    NSError *error = nil;
  
    if(_context != nil) {
        if([_context hasChanges] && ![_context save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
