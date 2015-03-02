//
//  CottageNewsTableViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 02.03.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "CottageNewsTableViewController.h"
#import "CottageNewsTableViewCell.h"
#import "NewsContentViewController.h"

@interface CottageNewsTableViewController ()

@property (strong, nonatomic) id<NSObject> newsFeedListAddNewsFeedObserver;
@property (strong, nonatomic) id<NSObject> newsFeedListAddNewsFeedFailObserver;
@property (strong, nonatomic) id<NSObject> newsFeedListRemoveNewsFeedObserver;
@property (strong, nonatomic) id<NSObject> addNewsFeedObserver;
@property (nonatomic) NSArray * newsItems;

@end

@implementation CottageNewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNewsFeedList:(NewsFeedList *)sourse
{
    if (_newsFeedListAddNewsFeedObserver != nil){
        [[NSNotificationCenter defaultCenter] removeObserver:_newsFeedListAddNewsFeedObserver];
    }
    if (_newsFeedListAddNewsFeedFailObserver != nil){
        [[NSNotificationCenter defaultCenter] removeObserver:_newsFeedListAddNewsFeedFailObserver];
    }
    if (_newsFeedListRemoveNewsFeedObserver != nil){
        [[NSNotificationCenter defaultCenter] removeObserver:_newsFeedListRemoveNewsFeedObserver];
    }
    
    _newsFeedList = sourse;
    [self updateNewsItemsFromNewsFeedsList: _newsFeedList];
    [self.tableView reloadData];
    
    _newsFeedListAddNewsFeedObserver = [[NSNotificationCenter defaultCenter] addObserverForName: (NSString*)NewsFeedListAddNewsFeedNotification object:sourse queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        [self updateNewsItemsFromNewsFeedsList: _newsFeedList];
        [self.tableView reloadData];
    }];
    
    _newsFeedListAddNewsFeedFailObserver = [[NSNotificationCenter defaultCenter] addObserverForName: (NSString*)NewsFeedListAddNewsFeedFailNotification object:sourse queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSString * ondNewsFeedTitle = [note.userInfo objectForKey:@"title"];
        NSString * message = @"Новостная лента уже существует.";
        if (ondNewsFeedTitle != nil){
            message = [NSString stringWithFormat:@"Новостная лента %@ уже существует.", ondNewsFeedTitle];
        }
        
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle: @"Невозможно добавить новостную ленту"
                                                           message: message
                                                          delegate: self
                                                 cancelButtonTitle: @"OK"
                                                 otherButtonTitles: nil];
        [theAlert show];
    }];
    
    _newsFeedListRemoveNewsFeedObserver = [[NSNotificationCenter defaultCenter] addObserverForName: (NSString*)NewsFeedListRemoveNewsFeedNotification object:sourse queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if (_newsItems != nil){
            BOOL isRemove = YES;
            
            [[self tableView]beginUpdates];
            for (int i = 0; i < _newsItems.count; i++) {
                isRemove = YES;
                NewsItem * oldNewsItem = [_newsItems objectAtIndex:i];
                for (NewsFeed * newNewsFeed in _newsFeedList.newsFeeds) {
                    if ([newNewsFeed.url isEqual:oldNewsItem.newsFeed.url]){
                        isRemove = NO;
                    }
                }
                if (isRemove){
                    [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]
                                            withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            [self updateNewsItemsFromNewsFeedsList: _newsFeedList];
            [[self tableView]endUpdates];
        }
    }];
}

-(void) updateNewsItemsFromNewsFeedsList: (NewsFeedList*) newsFeedsList{
    if (newsFeedsList == nil) return;
    if (newsFeedsList.newsFeeds == nil) return;
    
    NSMutableArray * newsItems = [NSMutableArray new];
    for (NewsFeed * newsFeed in newsFeedsList.newsFeeds) {
        for (NewsItem * newsItem in newsFeed.newsItems) {
            if (newsItem.isPin){
                [newsItems addObject:newsItem];
            }
        }
    }
    [self setNewsItems: newsItems];
}

- (void) setNewsItems: (NSArray *) newsItems {
    _newsItems = [newsItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NewsItem * item1 = (NewsItem *)obj1;
        NewsItem * item2 = (NewsItem *)obj2;
        return [item2.creationDate compare:item1.creationDate];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_newsItems) {
        return [_newsItems count];
    }
    else return 0;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 return [self basicCellAtIndexPath:indexPath];
 }
 
 - (CottageNewsTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
 CottageNewsTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"CottageNewsTableViewCell" forIndexPath:indexPath];
 [self configureNewsFeedCell:cell atIndexPath:indexPath];
 return cell;
 }

- (void)configureNewsFeedCell:(CottageNewsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NewsItem * newsItem = [ _newsItems objectAtIndex: indexPath.row ];
    
    cell.newsItem = newsItem;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static CottageNewsTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"CottageNewsTableViewCell"];
    });
    
    [self configureNewsFeedCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth([self tableView].frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = MAX(size.height + 1.0f, 82.0);
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NewsItem * item = [_newsItems objectAtIndex: indexPath.row];
        item.isPin = NO;
        NSMutableArray * newNewsItems = [NSMutableArray arrayWithArray:_newsItems];
        [newNewsItems removeObject:item];
        [self setNewsItems:newNewsItems];
        [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateNewsItemsFromNewsFeedsList:_newsFeedList];
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    UINavigationController * navigation = [segue destinationViewController];
    if ([[navigation topViewController] isKindOfClass:[NewsContentViewController class]])
    {
        NewsContentViewController * newsContent = (NewsContentViewController *)[navigation topViewController];
        
        NewsItem * item = [_newsItems objectAtIndex: [[self tableView] indexPathForCell:sender].row];
        item.isRead = YES;
        [newsContent setNewsItem: item];
    }
}

@end
