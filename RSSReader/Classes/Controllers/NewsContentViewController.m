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
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *titleTab;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebVew;

@property (nonatomic) NSString * newsTitle;
@property (nonatomic) NSString * newsCreationDate;
@property (nonatomic) NSString * newsContent;
@property (nonatomic) NSString * newsLinkString;
@property (nonatomic) NSDateFormatter * defaultDateFormatter;
@property (nonatomic) NSURL * url;

@end

@implementation NewsContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_newsTitle)
    {
        _titleLable.text = _newsTitle;
    }
    if (_newsCreationDate)
        self.dateLable.text = _newsCreationDate;
    else self.dateLable.text = @"";
    if (_newsContent)
        [self.contentWebVew loadHTMLString:_newsContent baseURL:nil];
    
    [self chackActiveLink];
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
        _newsLinkString = news.url;
        
        if (_newsTitle)
        {
            _titleLable.text = _newsTitle;
        }
        if (_newsCreationDate)
            self.dateLable.text = _newsCreationDate;
        else self.dateLable.text = @"";
        if (_newsContent)
        {
            NSRange loc = [_newsContent rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch];
            if (loc.length <= 0)
            {
                _newsContent = [NSString stringWithFormat:@"<p style=\"font-size: 16px; font-family: Arial; text-align: justify; margin: 0px 8px;\">%@<p>", _newsContent];
            }
            [self.contentWebVew loadHTMLString:_newsContent baseURL:nil];
        }
        _url = [NSURL URLWithString:_newsLinkString];
        
        [self chackActiveLink];
        [news setIsRead:[NSNumber numberWithBool:YES]];
        
        [self updateViewConstraints];
    }
}

-(void) chackActiveLink {
    if (_url && [[UIApplication sharedApplication] canOpenURL: _url]) {
        self.titleTab.enabled = YES;
        [self.titleLable setTextColor: [UIColor blueColor]];
    }
    else {
        self.titleTab.enabled = NO;
        [self.titleLable setTextColor: [UIColor blackColor]];
    }
}

- (IBAction)goLink:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL: _url])
        [[UIApplication sharedApplication] openURL: _url];
}

@end
