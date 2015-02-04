//
//  RSSListTableViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsContentViewController.h"
#import "NewsSourse.h"

@interface NewsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *rssList;
@property (weak, nonatomic) NewsSourse * sourse;
@property (nonatomic) UIRefreshControl * refreshControl;
@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rssList.dataSource = self;
    _rssList.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [self.rssList addSubview:_refreshControl];
    [_refreshControl addTarget:self action: @selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable {
    [_sourse downloadAgain];
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
    [_rssList reloadData];
    
}

- (void)newsSourse:(NewsSourse *) sourse didParseNews:(NSArray *)newsItems
{
    if (!_sourse)
        _sourse = sourse;
    
    [_refreshControl endRefreshing];
    
    self.newsList = newsItems;
}

- (void)newsSourse:(NewsSourse *) sourse didFailDownload:(NSError *) error
{
    [_refreshControl endRefreshing];
    
    NSString * message = @"Неизвестная ошибка.";
    
    if ([error.domain isEqualToString: NSURLErrorDomain])
    {
        if (error.code == NSURLErrorNetworkConnectionLost)
            message = @"Соединение потеряно";
        else
            message = @"Подключение к нтернету отсутствует";
    }
    
    UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle: @"Невозмо обновить ленту"
                                                       message: message
                                                      delegate: self
                                             cancelButtonTitle: @"OK"
                                             otherButtonTitles: nil];
    [theAlert show];
}

- (void)newsSourse:(NewsSourse *) sourse
{
    _sourse = sourse;
    [_sourse update];
}

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
    
    if ([newsItem.isRead boolValue])
        [cell setBackgroundColor:[UIColor clearColor]];
    else [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: NO ];
    [tableView reloadRowsAtIndexPaths: @[ indexPath ] withRowAnimation: UITableViewRowAnimationNone ];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    UINavigationController * navigation = [segue destinationViewController];
    if ([[navigation topViewController] isKindOfClass:[NewsContentViewController class]])
    {
        NewsContentViewController * newsContent = (NewsContentViewController *)[navigation topViewController];
    
        NewsItem * item = [_newsList objectAtIndex: [_rssList indexPathForCell:sender].row];
        [newsContent setNewsItem: item];
    }
}

@end
