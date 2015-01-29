//
//  DetailViewController.m
//  SWAGDemo
//
//  Created by Yose on 1/12/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "DetailViewController.h"
#import "BookValues.h"
#import "ServerBookManager.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextField;

@property (weak, nonatomic) IBOutlet UILabel *authorTextField;

@property (weak, nonatomic) IBOutlet UILabel *publisherTextField;

@property (weak, nonatomic) IBOutlet UILabel *tagsTextField;

@property (weak, nonatomic) IBOutlet UITextView *checkedOutTextField;

@end

@implementation DetailViewController

#pragma mark - Book information method


/**
 @description Displays the book information for the selected book
 */
- (void)bookInformation {
    _authorTextField.text = [[BookValues sharedManager] author];
    _titleTextField.text = [[BookValues sharedManager] bookTitle];
    _publisherTextField.text = [[BookValues sharedManager] publisher];
    _tagsTextField.text = [[BookValues sharedManager] bookCategories];
    
}

#pragma mark - View Controller default methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    /// populate the labels and textview with book information
    void (^populateBookInformation)(void) =
    ^{
        _authorTextField.text = [ServerBookManager author];
        _titleTextField.text = [ServerBookManager title];
        _publisherTextField.text = [ServerBookManager publisher];
        _tagsTextField.text = [ServerBookManager categories];
        _checkedOutTextField.text = [NSString stringWithFormat:@"%@%@.", [ServerBookManager lastCheckedOut], [ServerBookManager lastCheckedOutBy]];
 
    };
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        populateBookInformation();
    });
    
    NSLog(@"Last checked out by %@",[ServerBookManager lastCheckedOutBy]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
