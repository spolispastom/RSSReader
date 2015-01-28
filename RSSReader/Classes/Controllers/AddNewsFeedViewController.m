//
//  AddNewsFeedViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "AddNewsFeedViewController.h"

@interface AddNewsFeedViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *urlTextFild;

@end

@implementation AddNewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemURL = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) return;
    
    if (_urlTextFild.text.length > 0) {
        
        _itemURL =  _urlTextFild.text;

    }
}

@end
