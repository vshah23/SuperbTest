//
//  MainViewController.m
//  SuperbTest
//
//  Created by Vikas Shah on 3/15/14.
//  Copyright (c) 2014 Vikas Shah. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"

static NSString * const BaseURLString = @"https://itunes.apple.com/search?";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) NSArray *originalResultsArray;
@property (strong, nonatomic) NSArray *searchResultsArray;

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchController = [[UISearchDisplayController alloc]
                        
                        initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.delegate = self;
    
    self.searchController.searchResultsDataSource = self;
    
    self.searchController.searchResultsDelegate = self;
    
    [self updateResultsArraywithTerm:@"Superb" withArray:0 andTableView:self.tableView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.searchResultsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:2];
    NSDictionary *cellInfo;
    
    if (tableView == self.tableView) {
        cellInfo = (NSDictionary *)[self.originalResultsArray objectAtIndex:indexPath.row];
    } else {
        cellInfo = (NSDictionary *)[self.searchResultsArray objectAtIndex:indexPath.row];
    }
    
    //set the app title label
    label.text = [cellInfo valueForKey:@"trackCensoredName"];
    
    //set the thumbnail imagerb
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [cellInfo valueForKey:@"artworkUrl60"]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    imageView.image = image;
    
    return cell;
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"details"]) {
        DetailViewController *next = (DetailViewController *)segue.destinationViewController;
        if ([self.searchController isActive]) {
            NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            next.cellInfo = (NSDictionary *)[self.searchResultsArray objectAtIndex:indexPath.row];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            next.cellInfo = (NSDictionary *)[self.searchResultsArray objectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - Search Display

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self updateResultsArraywithTerm:searchBar.text withArray:1 andTableView:self.searchController.searchResultsTableView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 60;
}

#pragma mark - Searchbar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) aSearchBar {
    self.searchResultsArray = [NSArray arrayWithArray:self.originalResultsArray];
    [self.searchController.searchResultsTableView reloadData];
    [aSearchBar resignFirstResponder];
}

#pragma mark - AFNetworking

-(void) updateResultsArraywithTerm:(NSString *)term withArray:(int)i andTableView:(UITableView *)tableView
{
    NSString *string = [NSString stringWithFormat:@"%@term=%@&limit=10&entity=software&country=us", BaseURLString, [term stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        if (i == 0) {
            self.originalResultsArray = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"results"];
        }
        self.searchResultsArray = (NSArray *)[(NSDictionary *)responseObject valueForKey:@"results"];
        [tableView reloadData];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Apps List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}
@end
