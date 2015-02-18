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
#import "NewsFeed.h"
#import "NewsFeedSourse.h"
#import "NewsFeedTableViewCell.h"

@interface NewsFeedTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) NewsFeedSourse* sourse;

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)newsSourse:(NewsFeedSourse *) sourse didGetNewsFeed:(NSArray *)newsFeeds
{
    if (!_sourse)
        _sourse = sourse;
    _newsFeedList = newsFeeds;
    
    [self.tableView reloadData];
}

- (void)newsSourse:(NewsFeedSourse *) sourse
{
    _sourse = sourse;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_newsFeedList) {
        return [_newsFeedList count];
    }
    else return 0;
}

- (IBAction)unwindToNewsFeedTable:(UIStoryboardSegue *)segue
{
    AddNewsFeedViewController *addNewsSource = [segue sourceViewController];
    NSString * itemURL = addNewsSource.itemURL;
    if (itemURL != nil)
    {
        [_sourse addNewsFeed: addNewsSource.itemURL];
    }
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
    
    NewsFeed * newsFeedItem = [ _newsFeedList objectAtIndex: indexPath.row ];
    
    cell.title = newsFeedItem.title;
    cell.image = newsFeedItem.imageData;
    
    cell.numberOfUnreadNews = [[_sourse getNewsSourseFromNewsFeed:newsFeedItem] numberOfUnreadNews];
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
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = MAX(size.height + 1.0f, 82.0f); // Add 1.0f for the cell separator height
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NewsFeed * item = [_newsFeedList objectAtIndex: indexPath.row];
    
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [_sourse removeNewsFeed: item];
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
        
        NewsFeed * item = [_newsFeedList objectAtIndex: [self.tableView indexPathForCell:sender].row];
        NewsSourse * sourse = [_sourse getNewsSourseFromNewsFeed:item];
        sourse.sourseDelegate = newsContent;
        //[sourse update];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

@end
