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
    return [_newsFeedList count];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsFeedItem" forIndexPath:indexPath];
    
    NewsFeed * newsFeedItem = [ _newsFeedList objectAtIndex: indexPath.row ];
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    if (newsFeedItem.image != nil && newsFeedItem.image.length > 0)
    {
        UIImage * image = [[UIImage alloc]initWithData:newsFeedItem.image];
        
        CGImageRef imgRef = [image CGImage];
        CGFloat width = CGImageGetWidth(imgRef);
        CGFloat height = CGImageGetHeight(imgRef);
        CGSize size = CGSizeMake(width, height);
        
        if (height < width)
        {
            size.width = 44;
            size.height = 44 * height / width;
        }
        else
        {
            size.width = 44 * width / height;
            size.height = 44;
        }
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0.0, 0.0, size.width, size.height)];
        UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        recipeImageView.image = imageCopy;
    }
    else
        recipeImageView.image = [UIImage imageNamed: @"rss"];
    
    UILabel * titleLable = (UILabel *)[cell viewWithTag:101];
    titleLable.text = newsFeedItem.title;
    
    int numberOfUnreadNews = [[_sourse getNewsSourseFromNewsFeed:newsFeedItem] numberOfUnreadNews];
    
    UILabel * newsCountLable = (UILabel *)[cell viewWithTag:102];
    newsCountLable.text = [[NSString alloc] initWithFormat: @"%d", numberOfUnreadNews];

    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NewsFeed * item = [_newsFeedList objectAtIndex: indexPath.row];
        [_sourse removeNewsFeed: item];
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
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [_sourse saveContext];
    [self.tableView reloadData];
}

@end
