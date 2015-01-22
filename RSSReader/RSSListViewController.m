//
//  RSSListTableViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "RSSListViewController.h"
#import "NewsContentViewController.h"

@interface RSSListViewController ()
@property (weak, nonatomic) IBOutlet UITableView * RSSList;

@end

@implementation RSSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _RSSList.dataSource = self;
    _RSSList.delegate = self;
}

- (NSDateFormatter *)defaultDateFormatter {
    if(_defaultDateFormatter == nil) {
        _defaultDateFormatter = [[NSDateFormatter alloc] init];
        [_defaultDateFormatter setDateFormat:@"dd MMMM yyyy HH:mm"];
    }
    return _defaultDateFormatter;
}

- (void) setNewsList: (NSArray *) newsItemList
{
    _newsList = newsItemList;
    [_RSSList reloadData];
}


- (void) setNewsArray: (NSArray *) news;
{
    self.newsList = news;
}

NewsContentViewController * newsContent;

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_newsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [ tableView dequeueReusableCellWithIdentifier: @"ListPrototypeCell" forIndexPath: indexPath ];
    
    NewsItem * newsItem = [ _newsList objectAtIndex: indexPath.row ];
    cell.textLabel.text = newsItem.title;
    cell.detailTextLabel.text = [self.defaultDateFormatter stringFromDate: newsItem.creationDate];
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: NO ];
    [tableView reloadRowsAtIndexPaths: @[ indexPath ] withRowAnimation: UITableViewRowAnimationNone ];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if (!newsContent)
    {
        UINavigationController * navigation = [segue destinationViewController];
        if ([[navigation topViewController] isKindOfClass:[NewsContentViewController class]])
            newsContent = (NewsContentViewController *)[navigation topViewController];
    }
    NewsItem * item = [_newsList objectAtIndex: [_RSSList indexPathForCell:sender].row];
    [newsContent setNewsItem: item];
}

@end
