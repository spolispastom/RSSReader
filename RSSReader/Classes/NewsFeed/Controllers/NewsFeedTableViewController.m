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
    _newsFeedList = sourse;
    
    [[NSNotificationCenter defaultCenter] addObserverForName: (NSString*)NewsFeedListDidChangeNotification object:_newsFeedList queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSNumber * notificationType = [note.userInfo objectForKey:(NSString*)NewsFeedListChangeType];
        if (notificationType != nil){
            if (notificationType == [NSNumber numberWithInt: NewsFeedListChangeTypeAddNewsFeedFail]){
               
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
            }
        }
        
        [self updateNewsFeeds];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_newsFeedList) {
        return [_newsFeedList.newsFeeds count];
    }
    else return 0;
}

- (IBAction)unwindToNewsFeedTable:(UIStoryboardSegue *)segue
{
    AddNewsFeedViewController *addNewsSource = [segue sourceViewController];
  
    [_newsFeedList addNewsFeed: addNewsSource.itemURL];
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
    
    NewsFeed * newsFeedItem = [ _newsFeedList.newsFeeds objectAtIndex: indexPath.row ];
    
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
        
        NewsFeed * item = [_newsFeedList.newsFeeds objectAtIndex: indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [_newsFeedList removeNewsFeed: item];
        [tableView endUpdates];
        
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController * navigation = [segue destinationViewController];
    if ([[navigation topViewController] isKindOfClass:[NewsListViewController class]])
    {
        NewsListViewController * newsContent = (NewsListViewController *)[navigation topViewController];
        
        NewsFeed * item = [_newsFeedList.newsFeeds objectAtIndex: [self.tableView indexPathForCell:sender].row];
        newsContent.newsFeed = item;
        //[sourse update];
    }
}

- (void) showNewsItemFromURL: (NSURL*) url
{
    UIViewController * controller  = [[self storyboard] instantiateViewControllerWithIdentifier: @"NewsListViewController"];
    
    if ([controller isKindOfClass:[NewsListViewController class]])
    {
        NewsListViewController * newsContent = (NewsListViewController *)controller;
        
        
        for (NewsFeed * newsFeed in _newsFeedList.newsFeeds) {
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
