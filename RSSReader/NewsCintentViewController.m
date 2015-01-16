//
//  NewsCintentViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsCintentViewController.h"

@interface NewsCintentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NewsCintentViewController

- (NewsCintentViewController *) initFronNewsItem: (NewsItem *) news
{
    self = [super init];
    
    defaultDateFormatter = [[NSDateFormatter alloc] init];
    [defaultDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    _titleLable.text = news.Title;
    _dateLable.text = [defaultDateFormatter stringFromDate:news.CreationDate];
    _contentTextView.text = news.Content;
    
    return self;
}


NSDateFormatter * defaultDateFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
