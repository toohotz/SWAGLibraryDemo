//
//  bookCheckOutViewController.m
//  SWAGDemo
//
//  Created by Yose on 1/19/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "BookCheckOutViewController.h"
#import "ServerBookManager.h"

@interface BookCheckOutViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation BookCheckOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    _nameTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    
    [_nameTextField resignFirstResponder];
    if (_nameTextField.text.length > 1) {
        [ServerBookManager editBookAtIndex:[ServerBookManager currentBookIndex] editedBy:_nameTextField.text];
    }

    
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    
    
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
