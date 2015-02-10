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
    
    [self navigationItem].title = _newsFeedTitle;
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

- (void)newsSourse:(NewsSourse *) sourse didParseNews:(NSArray *)newsItems andTitle:(NSString *)title
{
    if (!_sourse)
        _sourse = sourse;
    
    [_refreshControl endRefreshing];
    
    self.newsList = newsItems;
    self.newsFeedTitle = title;
    
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

- (UITableViewCell *)tableView1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [ tableView dequeueReusableCellWithIdentifier: @"ListPrototypeCell" forIndexPath: indexPath ];
    
    NewsItem * newsItem = [ _newsList objectAtIndex: indexPath.row ];
    
    ((UILabel *)[cell viewWithTag:100]).text = newsItem.title;
    
   
    ((UILabel *)[cell viewWithTag:101]).text = [self.defaultDateFormatter stringFromDate: newsItem.creationDate];

    if ([newsItem.isRead boolValue])
        [cell setBackgroundColor:[UIColor clearColor]];
    else [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1]];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self basicCellAtIndexPath:indexPath];
}

- (UITableViewCell *)basicCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_rssList dequeueReusableCellWithIdentifier:@"ListPrototypeCell"
                                                           forIndexPath:indexPath];
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureBasicCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NewsItem * newsItem = [ _newsList objectAtIndex: indexPath.row ];
    
    ((UILabel *)[cell viewWithTag:100]).text = newsItem.title;
    
    
    ((UILabel *)[cell viewWithTag:101]).text = [self.defaultDateFormatter stringFromDate: newsItem.creationDate];
    
    if ([newsItem.isRead boolValue])
        [cell setBackgroundColor:[UIColor clearColor]];
    else [cell setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:1 alpha:1]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static UITableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [_rssList dequeueReusableCellWithIdentifier:@"ListPrototypeCell"];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(_rssList.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if (size.height < 82)
        return 82;
    else return size.height + 1.0f; // Add 1.0f for the cell separator height
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
