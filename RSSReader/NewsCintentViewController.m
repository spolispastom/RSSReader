//
//  NewsCintentViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 16.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "NewsCintentViewController.h"
#import "SelectionContext.h"

@interface NewsCintentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dateLable;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NewsCintentViewController

- (NewsCintentViewController *) init
{
    self = [super init];
    
    return self;
}

- (void) setCurrentNewsItem: (NewsItem *) item
{
    if (item){
      }
}

NSDateFormatter * defaultDateFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    defaultDateFormatter = [[NSDateFormatter alloc] init];
    [defaultDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    NewsItem * news = [SelectionContext Instance].SelectionNews;
    
    self.titleLable.text = news.Title;
    self.dateLable.text = [defaultDateFormatter stringFromDate: news.CreationDate];
    self.contentTextView.text = news.Content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Nzavigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
