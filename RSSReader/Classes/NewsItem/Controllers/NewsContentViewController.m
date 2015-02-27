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
@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIWebView *contentWebVew;

@property (nonatomic) NSDateFormatter * defaultDateFormatter;

@end

@implementation NewsContentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_newsItem)
    {
        _titleLable.text = _newsItem.title;
    
        self.dateLable.text = [_defaultDateFormatter stringFromDate:_newsItem.creationDate];

        [self.contentWebVew loadHTMLString:[NSString stringWithFormat:@"<p style=\"font-size: 16px; font-family: Arial; text-align: justify; margin: 0px;\">%@<p>", _newsItem.content] baseURL:nil];
        
        _pinButton.selected = _newsItem.isPin;
    }
    _contentWebVew.delegate = self;
    
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
        _newsItem = news;
        
        if (_newsItem)
        {
            _titleLable.text = _newsItem.title;
            
            self.dateLable.text = [_defaultDateFormatter stringFromDate:_newsItem.creationDate];
            
            [self.contentWebVew loadHTMLString:[NSString stringWithFormat:@"<p style=\"font-size: 16px; font-family: Arial; text-align: justify; margin: 0px;\">%@<p>", _newsItem.content] baseURL:nil];
            
            _pinButton.selected = _newsItem.isPin;
        }
        
        [self chackActiveLink];
        news.isRead = YES;
        
        [self updateViewConstraints];
    }
}

- (IBAction)pinButtonTouchDown:(id)sender {
    _newsItem.isPin = !_newsItem.isPin;
    
    _pinButton.selected = _newsItem.isPin;
}

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType{
    NSURL * url = request.URL;
    if (url.host == nil){
        return YES;
    }
    else{
        if ([[UIApplication sharedApplication] canOpenURL: url])
            [[UIApplication sharedApplication] openURL: url];

        return NO;
    }
}

-(void) chackActiveLink {
    if (_newsItem.url && [[UIApplication sharedApplication] canOpenURL: _newsItem.url]) {
        self.titleTab.enabled = YES;
        [self.titleLable setTextColor: [UIColor blueColor]];
    }
    else {
        self.titleTab.enabled = NO;
        [self.titleLable setTextColor: [UIColor blackColor]];
    }
}

- (IBAction)goLink:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL: _newsItem.url])
        [[UIApplication sharedApplication] openURL: _newsItem.url];
}

@end
