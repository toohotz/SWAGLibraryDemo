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
#import <Social/Social.h>

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextField;

@property (weak, nonatomic) IBOutlet UILabel *authorTextField;

@property (weak, nonatomic) IBOutlet UILabel *publisherTextField;

@property (weak, nonatomic) IBOutlet UILabel *tagsTextField;

@property (weak, nonatomic) IBOutlet UITextView *checkedOutTextField;

// Static properties

@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
//    load up book view information

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        [ServerBookManager retrieveBookAtIndex:[ServerBookManager currentBookIndex] completionHandler:^(NSDictionary *dictionary, NSError *error) {
            
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _authorTextField.text = [dictionary objectForKey:@"author"];
                    _titleTextField.text = [dictionary objectForKey:@"title"];
                    _publisherTextField.text = [dictionary objectForKey:@"publisher"];
                    _tagsTextField.text = [dictionary objectForKey:@"categories"];
                    _checkedOutTextField.text = [NSString stringWithFormat:@"%@%@.", [dictionary objectForKey:@"lastCheckedOut"], [dictionary objectForKey:@"lastCheckedOutBy"]];
                });
                
            }
            
            if (error) {
                NSLog(@"An error occurred. %@", error.localizedDescription);
            }
        }];
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

        _authorTextField.alpha = 0;
        _titleTextField.alpha = 0;
        _publisherTextField.alpha = 0;
        _tagsTextField.alpha = 0;
        _publisherLabel.alpha = 0;
        _tagsLabel.alpha = 0;
        _checkedOutTextField.alpha = 0;
        _checkoutButton.alpha = 0;

    
    
    /// populate the labels and textview with book information
    void (^populateBookInformation)(void) =
    ^{
        _authorTextField.text = [ServerBookManager author];
        _titleTextField.text = [ServerBookManager title];
        _publisherTextField.text = [ServerBookManager publisher];
        _tagsTextField.text = [ServerBookManager categories];
        _checkedOutTextField.text = [NSString stringWithFormat:@"%@%@.", [ServerBookManager lastCheckedOut], [ServerBookManager lastCheckedOutBy]];
 
    };
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self fadeInText];
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fade In Text Transition
/**
 @description Fades in text onto screen
 */
-(void)fadeInText
{
    /*
     This function's purpose is to give the View Controller time to 
     access the ServerBookManager and retrieve the neccessary information
     in a user friendly manner
     */
    
    [UIView animateWithDuration:0.65f animations:^{
        _authorTextField.alpha = 1;
        _titleTextField.alpha = 1;
        _publisherTextField.alpha = 1;
        _tagsTextField.alpha = 1;
        _publisherLabel.alpha = 1;
        _tagsLabel.alpha = 1;
        _checkedOutTextField.alpha = 1;
        _checkoutButton.alpha = 1;

    }];
    
}


#pragma mark - Share to Twitter and Facebook

- (IBAction)shareToSocialMedia:(UIBarButtonItem *)sender {
    
    
    NSString *stringToSend = [NSString stringWithFormat:@"Check out my latest book that I recently checked out named %@.", _titleTextField.text];
    
    NSArray *activityItems = [[NSArray alloc] initWithObjects:stringToSend, nil];
    
    UIActivityViewController *activityController =
    [[UIActivityViewController alloc]
     initWithActivityItems:activityItems applicationActivities:nil];
    
    
    [self presentViewController:activityController animated:YES completion:nil];
    
    /*
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitterSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitterSheet setInitialText:[NSString stringWithFormat:@"Check out my latest book that I recently checked out named %@", _titleTextField.text]];
    [self presentViewController:twitterSheet animated:YES completion:nil];
    }
    */
}



@end
