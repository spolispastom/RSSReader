//
//  NewsFeedTableViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "AddNewsFeedViewController.h"
#import "NewsListViewController.h"
#import "NewsFeedList.h"
#import "NewsFeedTableViewCell.h"

@interface NewsFeedTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) id<NSObject> newsFeedListAddNewsFeedObserver;
@property (strong, nonatomic) id<NSObject> newsFeedListAddNewsFeedFailObserver;
@property (strong, nonatomic) id<NSObject> newsFeedListRemoveNewsFeedObserver;
@property (strong, nonatomic) id<NSObject> addNewsFeedObserver;
@property (nonatomic) NSArray * newsFeeds;

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateNewsFeeds{
    [self.tableView reloadData];
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
    
    _newsFeedListAddNewsFeedObserver = [[NSNotificationCenter defaultCenter] addObserverForName: (NSString*)NewsFeedListAddNewsFeedNotification object:sourse queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        _newsFeeds = _newsFeedList.newsFeeds;
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
        if (_newsFeeds != nil){
            BOOL isRemove = YES;
            
            [[self tableView]beginUpdates];
            for (int i = 0; i < _newsFeeds.count; i++) {
                isRemove = YES;
                NewsFeed * oldNewsFeed = [_newsFeeds objectAtIndex:i];
                for (NewsFeed * newNewsFeed in _newsFeedList.newsFeeds) {
                    if ([newNewsFeed.url isEqual:oldNewsFeed.url]){
                        isRemove = NO;
                    }
                }
                if (isRemove){
                    [[self tableView] deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]
                                            withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
            _newsFeeds = _newsFeedList.newsFeeds;
            [[self tableView]endUpdates];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_newsFeedList) {
        return [_newsFeeds count];
    }
    else return 0;
}


- (IBAction)unwindToNewsFeedTable:(UIStoryboardSegue *)segue
{
    if (_addNewsFeedObserver != nil){
        [[NSNotificationCenter defaultCenter] removeObserver:_addNewsFeedObserver];
    }
    _addNewsFeedObserver = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}

- (NewsFeedTableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    NewsFeedTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"newsFeedItem" forIndexPath:indexPath];
    [self configureNewsFeedCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureNewsFeedCell:(NewsFeedTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NewsFeed * newsFeedItem = [ _newsFeeds objectAtIndex: indexPath.row ];
    
    cell.title = newsFeedItem.title;
    cell.image = newsFeedItem.image;
    
    cell.numberOfUnreadNews = [newsFeedItem numberOfUnreadNews];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static NewsFeedTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"newsFeedItem"];
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
        
        NewsFeed * item = [_newsFeeds objectAtIndex: indexPath.row];
        [_newsFeedList removeNewsFeed: item];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController * navigation = [segue destinationViewController];
    if ([[navigation topViewController] isKindOfClass:[NewsListViewController class]])
    {
        NewsListViewController * newsContent = (NewsListViewController *)[navigation topViewController];
        
        NewsFeed * item = [_newsFeeds objectAtIndex: [self.tableView indexPathForCell:sender].row];
        newsContent.newsFeed = item;
        //[sourse update];
    } else if ([[navigation topViewController] isKindOfClass:[AddNewsFeedViewController class]]){
        AddNewsFeedViewController * addNewsSource = (AddNewsFeedViewController *)[navigation topViewController];
        _addNewsFeedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:(NSString*)AddNewsFeedViewControllerCompliteNotification object:addNewsSource queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            if (addNewsSource.itemURL!= nil){
                [_newsFeedList addNewsFeed: addNewsSource.itemURL];
            }
        }];
    }
}

- (void) showNewsItemFromURL: (NSURL*) url
{
    UIViewController * controller  = [[self storyboard] instantiateViewControllerWithIdentifier: @"NewsListViewController"];
    
    if ([controller isKindOfClass:[NewsListViewController class]])
    {
        NewsListViewController * newsContent = (NewsListViewController *)controller;
        
        
        for (NewsFeed * newsFeed in _newsFeeds) {
            if ([newsFeed.url isEqual:url]){
                
                newsContent.newsFeed = newsFeed;
                
                [self.navigationController pushViewController:newsContent animated:YES];
                return;
            }
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

@end
