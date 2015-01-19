//
//  NewsCintentViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsContentViewController.h"

@interface NewsContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NewsContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (title)
        self.titleLable.text = title;
    if (creationDate)
        self.dateLable.text = creationDate;
    if (content)
        self.contentTextView.text = content;
}

NSDateFormatter * defaultDateFormatter;

NSString * title;
NSString * creationDate ;
NSString * content;

- (void) setNewsItem: (NewsItem *) news;
{
    if (!defaultDateFormatter)
    {
        defaultDateFormatter = [[NSDateFormatter alloc] init];
        [defaultDateFormatter setDateFormat:@"dd MMMM YYYY HH:mm"];
    }
    
    if (news)
    {
        title = news.title;
        creationDate = [defaultDateFormatter stringFromDate: news.creationDate];
        content = news.content;
        
        if (title)
            self.titleLable.text = title;
        if (creationDate)
            self.dateLable.text = creationDate;
        if (content)
            self.contentTextView.text = content;
        
        [self updateViewConstraints];
    }
}

@end
