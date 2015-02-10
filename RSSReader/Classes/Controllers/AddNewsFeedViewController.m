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
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrolView;
@property (nonatomic) NSInteger offsetOfKeyboard;
@property (nonatomic) BOOL isViewMovedUp;

@end

@implementation AddNewsFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemURL = nil;
    
    _offsetOfKeyboard = 80;
    _isViewMovedUp = false;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    [_urlTextFild becomeFirstResponder];
}


- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (!_isViewMovedUp)
    {
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}

- (void)kyboardWillHide:(NSNotification*)aNotification
{
    if (_isViewMovedUp)
    {
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}


-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    
    _isViewMovedUp = movedUp;
    if (movedUp)
    {
        rect.origin.y -= _offsetOfKeyboard;
        rect.size.height += _offsetOfKeyboard;
    }
    else
    {
        rect.origin.y += _offsetOfKeyboard;
        rect.size.height -= _offsetOfKeyboard;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (IBAction)urlTextChanged:(id)sender {
    if (_urlTextFild.text.length > 0) {
        [_saveButton setEnabled: YES];
    }
    else {
        [_saveButton setEnabled: NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) return;
    
    if (_urlTextFild.text.length > 0) {
        
        _itemURL =  _urlTextFild.text;
    }
}

@end
