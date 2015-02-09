//
//  AddBookViewController.m
//  SWAGDemo
//
//  Created by Yose on 1/15/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "AddBookViewController.h"
#import "ServerBookManager.h"

@interface AddBookViewController ()

@property (weak, nonatomic) IBOutlet UITextField *authorTF;

@property (weak, nonatomic) IBOutlet UITextField *bookTitleTF;

@property (weak, nonatomic) IBOutlet UITextField *publisherTF;

@property (weak, nonatomic) IBOutlet UITextField *categoriesTF;


@end


@implementation AddBookViewController





- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)submitBookInformation:(id)sender {
    
    __block NSDictionary *paramters;
    
    
//    make sure all fields are valid so "empty" books aren't created on server
    
    if ((_authorTF.text.length >= 1 && _authorTF.text.length <= 3) || (_bookTitleTF.text.length >= 1 && _bookTitleTF.text.length <= 3) || (_publisherTF.text.length >= 1 && _publisherTF.text.length <= 3) || (_categoriesTF.text.length >= 1 && _categoriesTF.text.length <= 3) || _authorTF.text.length == 0  || _bookTitleTF.text.length == 0 || _publisherTF.text.length == 0 || _categoriesTF.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"It seems like you didn't enter valid book information" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
        else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
        void (^bookParameterSetter)(void) =
        ^{
            paramters = @{@"author": _authorTF.text,
                          @"title": _bookTitleTF.text,
                          @"publisher": _publisherTF.text,
                          @"categories": _categoriesTF.text,
                          @"lastCheckedOut": @"",
                          @"lastCheckedOutBy": @"",
                          @"id": [ServerBookManager nextBookNumber],
                          };
        };
        
        bookParameterSetter();
        
        [ServerBookManager createNewBookWithInformation:paramters completionHandler:^(BOOL wasSuccessful, NSError *error) {
           
            if (wasSuccessful) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sweet" message:@"Your book has been added to the library" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
            
            else if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sweet" message:[NSString stringWithFormat:@"Something went wrong creating your book. Error - %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
  
}


-(IBAction)closeVC:(UIBarButtonItem *)sender
{
   
    if ((_authorTF.text.length >= 1 && _authorTF.text.length <= 3) || (_bookTitleTF.text.length >= 1 && _bookTitleTF.text.length <= 3) || (_publisherTF.text.length >= 1 && _publisherTF.text.length <= 3) || (_categoriesTF.text.length >= 1 && _categoriesTF.text.length <= 3)) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"It seems like you didn't enter valid book information" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    else if ((_authorTF.text.length == 0 && _bookTitleTF.text.length == 0 && _publisherTF.text.length == 0) && _categoriesTF.text.length == 0) {
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Field Checks

/**
 @description Checks user fields to see if any information was left unfinished
 @returns true If user has completed all fields
 @returns false If user has left a field blank
 */


#pragma mark - UITextField delegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _bookTitleTF) {
        [_authorTF becomeFirstResponder];
    }
   
    else if (textField == _authorTF)
    {
        [_publisherTF becomeFirstResponder];
    }
    
    else if (textField == _publisherTF)
    {
        [_categoriesTF becomeFirstResponder];
    }
    
    else if (textField == _categoriesTF)
    {
        [self submitBookInformation:nil];
    }
    
    return TRUE;
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
