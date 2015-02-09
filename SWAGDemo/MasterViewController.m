//
//  MasterViewController.m
//  SWAGDemo
//
//  Created by Yose on 1/12/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ServerBookManager.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
/// Array of authors of all books
@property (nonatomic) NSMutableArray *listAuthors;
/// Array of all book titles
@property (nonatomic) NSMutableArray *listTitles;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [ServerBookManager retrieveTableViewBookInformation];
    [self reloadTableViewDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toCreateBookSegue:)];
    self.navigationItem.rightBarButtonItem = addButton;
    

//    dispatch after is required due to the time it takes to access the singleton values managed by ServerBookManager
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _listAuthors = [ServerBookManager bookAuthors];
        _listTitles = [ServerBookManager bookTitles];
        [self.tableView reloadData];
    });
    
    /// Refresh controller for tableview
    void (^refreshControlSetup)(void) =
    ^{
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor cyanColor];
        self.refreshControl.tintColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self action:@selector(reloadTableViewDataSource) forControlEvents:(UIControlEventValueChanged)];
    };
    
    refreshControlSetup();
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        
//        [ServerBookManager retrieveBookAtIndex:[[ServerBookManager bookIDs] objectAtIndex:indexPath.row]];
        
        [ServerBookManager setCurrentBookIndex:[[ServerBookManager bookIDs] objectAtIndex:indexPath.row]];

    }
}

/**
 @description Sends user to the create a new book page
 @param sender The UIBarButtonItem sending the request

 */
-(void)toCreateBookSegue:(UIBarButtonItem*)sender
{
    [self performSegueWithIdentifier:@"addBook" sender:sender];
}


#pragma mark - Table View

/**
 @description Reloads the tableview after the datasource is retrieved from the server
 */
-(void)reloadTableViewDataSource
{
    
//    using async queue
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        [ServerBookManager retrieveTableViewBookInformationWithCompletion:^(NSArray *array, NSError *error) {
            
            if (array) {
                _listTitles = [array valueForKey:@"title"];
                _listAuthors = [array valueForKey:@"author"];
            }
            
            else if (error)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:[NSString stringWithFormat:@"It appears something went wrong. Error - %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                NSLog(@"An error occurred retrieving the tableview book information. %@ - %@", error.localizedFailureReason, error.localizedDescription);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];

    });

    
    [self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listAuthors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [_listTitles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [_listAuthors objectAtIndex:indexPath.row];
  
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [ServerBookManager deleteBookAtIndex:indexPath.row];
 
        [_listAuthors removeObjectAtIndex:indexPath.row];
        [_listTitles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
