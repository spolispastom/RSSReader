//
//  NewsCintentViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsContentViewController.h"

@interface NewsContentViewController ()
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (nonatomic) NSString * newsTitle;
@property (nonatomic) NSString * newsCreationDate;
@property (nonatomic) NSString * newsContent;
@property (nonatomic) NSString * newsLinkString;
@property (nonatomic) NSDateFormatter * defaultDateFormatter;

@end

@implementation NewsContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_newsTitle)
        [self.titleButton setTitle: _newsTitle forState: UIControlStateNormal];
    if (_newsCreationDate)
        self.dateLable.text = _newsCreationDate;
    if (_newsContent)
        self.contentTextView.text = _newsContent;
    
}


- (void) setNewsItem: (NewsItem *) news;
{
    if (!_defaultDateFormatter)
    {
        _defaultDateFormatter = [[NSDateFormatter alloc] init];
        [_defaultDateFormatter setDateFormat:@"dd MMMM YYYY HH:mm"];
    }
    
    if (news)
    {
        _newsTitle = news.title;
        _newsCreationDate = [_defaultDateFormatter stringFromDate: news.creationDate];
        _newsContent = news.content;
        _newsLinkString = news.link;
        
        if (_newsTitle)
            [self.titleButton setTitle: _newsTitle forState: UIControlStateNormal];
        if (_newsCreationDate)
            self.dateLable.text = _newsCreationDate;
        if (_newsContent)
            self.contentTextView.text = _newsContent;
        
        
        [self updateViewConstraints];
    }
}
- (IBAction)goLink:(id)sender {
    NSURL * url = [NSURL URLWithString:_newsLinkString];
    
    if ([[UIApplication sharedApplication] canOpenURL: url])
        [[UIApplication sharedApplication] openURL: url];
}

@end
