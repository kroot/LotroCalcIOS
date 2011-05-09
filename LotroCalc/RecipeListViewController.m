//
//  RecipeListViewController.m
//  LotroCalc
//
//  Created by kroot on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecipeListViewController.h"
#import "LotroWSServices.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"

@implementation RecipeListViewController

@synthesize recipeNames = _recipeNames;
//@synthesize UITableView recipeView;
@synthesize profession;
@synthesize tier;
@synthesize activityView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_recipeNames release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    recipeView.hidden = true;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.tableView..hidden = true;
    recipeView.hidden = TRUE;

    /* self.recipeNames = [[NSMutableArray alloc] initWithObjects:
                  @"x", 
                  @"y", 
                  @"z",
                  @"Artisan",
                  @"Master",
                  @"Supreme",
                  nil
                  ];
     */
    
    LotroWSLotroCalc* service = [LotroWSLotroCalc service];
    service.logging = YES;
    [service GetRecipeNames:self action:@selector(GetRecipeNamesHandler:) 
                 profession: self.profession 
                       tier: self.tier];
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    self.title = @"Loading recipe names...";
    
    activityView = [[UIView alloc] init];
    activityView.frame = self.tableView.frame;
    // save this view somewhere
    
    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGRect frame = activityView.frame;
    ac.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [activityView addSubview:ac];    
    
    [ac startAnimating];
    [ac release];
    
    [self.tableView addSubview:activityView];
    [activityView release];
}

- (void) GetRecipeNamesHandler: (id) value {
    //return;
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
		NSLog(@"%@", value);
		return;
	}
    
	// Handle faults
	if([value isKindOfClass:[SoapFault class]]) {
		NSLog(@"%@", value);
		return;
	}				
    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    
	NSLog(@"GetRecipeNames returned the value: %@", result);
    for (NSMutableString *ret in result) {
        NSLog(@"%@\n", ret);
        
        NSString *dec = [StringEncryption DecryptString:ret];
        NSLog(@"dec = %@\n", dec);
        
        [newArray addObject:dec];
    }
    
    self.recipeNames = newArray;
    [self.tableView reloadData];
    //self.tableView.hidden = false;
    
    [activityView removeFromSuperview];
    self.title = @"Recipe Names";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recipeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [self.recipeNames objectAtIndex:[indexPath row]];
 
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
