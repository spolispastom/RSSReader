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
@property (nonatomic) NSURL * url;

@end

@implementation NewsContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleButton setTitleColor: [UIColor blueColor] forState:(UIControlStateNormal)];
    [self.titleButton setTitleColor: [UIColor blackColor] forState:(UIControlStateDisabled)];
    
    if (_newsTitle)
        [self.titleButton setTitle: _newsTitle forState: UIControlStateNormal];
    if (_newsCreationDate)
        self.dateLable.text = _newsCreationDate;
    if (_newsContent)
        self.contentTextView.text = _newsContent;
    
    if (_url && [[UIApplication sharedApplication] canOpenURL: _url])
        self.titleButton.enabled = YES;
    else self.titleButton.enabled = NO;
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
            [self.titleButton setTitle: _newsTitle forState: UIControlStateNormal];
        if (_newsCreationDate)
            self.dateLable.text = _newsCreationDate;
        if (_newsContent)
            self.contentTextView.text = _newsContent;
        _url = [NSURL URLWithString:_newsLinkString];
        
        if (_url && [[UIApplication sharedApplication] canOpenURL: _url])
            self.titleButton.enabled = YES;
        else self.titleButton.enabled = NO;
        
        [news setIsRead:[NSNumber numberWithBool:YES]];
        
        [self updateViewConstraints];
    }
}
- (IBAction)goLink:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL: _url])
        [[UIApplication sharedApplication] openURL: _url];
}

@end
