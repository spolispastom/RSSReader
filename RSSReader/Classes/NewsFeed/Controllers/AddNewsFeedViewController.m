//
//  AddNewsFeedViewController.m
//  RSSReader
//
//  Created by Михаил Куренков on 27.01.15.
//  Copyright (c) 2015 Михаил Куренков. All rights reserved.
//

#import "AddNewsFeedViewController.h"

NSString const * AddNewsFeedViewControllerCompliteNotification = @"AddNewsFeedViewControllerCompliteNotification";

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


- (IBAction)urlTextChanged:(id)sender {
    [_saveButton setEnabled: [self validatedURL] != nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (sender != self.saveButton) return;
    
    _itemURL =  [self validatedURL];
    [[NSNotificationCenter defaultCenter] postNotificationName:(NSString*)AddNewsFeedViewControllerCompliteNotification object:self];
}

- (NSURL *) validatedURL {
    if (_urlTextFild.text.length > 0){
        NSString * tempUrlString = _urlTextFild.text;

        NSURL* url = [NSURL URLWithString:tempUrlString];
        if (url != nil && [[UIApplication sharedApplication] canOpenURL:url]){
            return url;
        }
    }
    return nil;
}

#pragma mark -

@end
