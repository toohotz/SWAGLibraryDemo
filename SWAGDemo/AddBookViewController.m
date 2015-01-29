//
//  AddBookViewController.m
//  SWAGDemo
//
//  Created by Yose on 1/15/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "AddBookViewController.h"
#import "ServerBookManager.h"
#import "BookValues.h"

@interface AddBookViewController ()

@property (weak, nonatomic) IBOutlet UITextField *authorTF;

@property (weak, nonatomic) IBOutlet UITextField *bookTitleTF;

@property (weak, nonatomic) IBOutlet UITextField *publisherTF;

@property (weak, nonatomic) IBOutlet UITextField *categoriesTF;


@end


@implementation AddBookViewController





- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSLog(@"The book ids are %@", [ServerBookManager bookIDs]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)closeVC:(UIButton*)sender
{
    __block NSDictionary *paramters;
    
    void (^singletonSetters)(void) =
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
    
    singletonSetters(); 
    
    NSLog(@"The author from add book is %@", [[BookValues sharedManager] author]);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ServerBookManager createNewBookWithInformation:paramters];

    });
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    [textField resignFirstResponder];
    

    /// Verifies that user has filled in all fields
    BOOL (^userFieldsCompleted)(void) =
    ^{
        BOOL finished;
        
        if (textField.text.length < 1) {
            finished = FALSE;
        }
        
        else
        {
            finished = TRUE;
        }
        
        return finished;
    };
    
    
    
    if (userFieldsCompleted() == TRUE) {
        NSLog(@"All fields filled in.");
 
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    else if (userFieldsCompleted() == FALSE)
    {
        NSLog(@"Some fields are missing.");
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
