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
@property (weak, nonatomic) IBOutlet UIView *scrolVewCintentView;

@end

@implementation AddNewsFeedViewController

#pragma mark - viewLifeСycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect fs = _mainScrolView.frame;
    _mainScrolView.contentSize = fs.size;
    
    _itemURL = nil;
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
   
    
    [self addObserversOnKeyboardNotification];
    
    [_urlTextFild becomeFirstResponder];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self removeObserverOnKeyboardNotification];
}

-(void)addObserversOnKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)removeObserverOnKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}



#pragma mark - keybord
//contentInset
//convertRect...
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    CGRect kbRect = [self.view convertRect:
                     [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                  fromView:nil];

    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbRect.size.height, 0);
        _mainScrolView.contentInset = contentInsets;
        _mainScrolView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)kyboardWillHide:(NSNotification*)aNotification
{
    CGRect kbRect = [self.view convertRect:
                     [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                                  fromView:nil];

    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(kbRect.size.height, 0, 0, 0);
        _mainScrolView.contentInset = contentInsets;
        _mainScrolView.scrollIndicatorInsets = contentInsets;
    }];
}


//через делегат
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

#pragma mark -

@end
