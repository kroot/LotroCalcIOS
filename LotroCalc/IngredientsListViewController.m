//
//  IngredientsListViewController.m
//  LOTRO Calc
//
//  Created by kroot on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IngredientsListViewController.h"
#import "LotroWSServices.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"
#import "MBProgressHUD.h"

@implementation IngredientsListViewController

@synthesize profession;
@synthesize tier;
@synthesize recipeName;

@synthesize ingNames;
@synthesize ingQtys;


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
    
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Ingredients" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    [newBackButton release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
	
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    HUD.detailsLabelText = @"from CraftingCalc.com";
	
    [HUD show:YES];

    LotroWSLotroCalc* service = [LotroWSLotroCalc service];
    service.logging = NO;
    [service GetRecipeIngredients:self  action:@selector(GetRecipeIngredientsHandler:) recipeName:recipeName quantity:1 ];    
    
    [super viewWillAppear:animated];
    
    self.title = @"Loading...";
}
     

- (void) GetRecipeIngredientsHandler: (id) value {

    self.title = self.recipeName;    
    [HUD hide:YES];

    // Handle errors
	if([value isKindOfClass:[NSError class]]) {
		//NSLog(@"%@", value);
        
        NSString *errMsg = [value localizedDescription];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" 
            message:errMsg delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alert show];	
        [alert release];
        
		return;
	}
    
	// Handle faults
	else if([value isKindOfClass:[SoapFault class]]) {
		//NSLog(@"%@", value);
        
 		//NSLog(@"%@", value);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" 
            message:value delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alert show];	
        [alert release];       
       
		return;
	}				
    
 	//if([value isKindOfClass:[LotroWSWebIngredient class]]) {
    NSMutableArray* result = (NSMutableArray*)value;
    NSMutableArray *newIngNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngQtyArray = [[NSMutableArray alloc] init];
    
    if ([result count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" 
            message:@"Unable to read recipe data" delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alert show];	
        [alert release];               
    }

    for (LotroWSWebIngredient *ing in result) {
        //NSLog(@"%@", ing.IngredientName);

        NSString *dec = [StringEncryption DecryptString:ing.IngredientName];
        //NSLog(@"dec = %@\n", dec);
        
        [newIngNameArray addObject:dec];  
        NSString *qty = [@"Quantity: " stringByAppendingFormat:@"%d", ing.Quantity];
        [newIngQtyArray addObject:qty];       
    }	
    self.ingNames = newIngNameArray;
    self.ingQtys = newIngQtyArray;

    [self.tableView reloadData];
    
    //[activityView removeFromSuperview];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.ingNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [self.ingNames objectAtIndex:[indexPath row]];
    cell.detailTextLabel.text = [self.ingQtys objectAtIndex:[indexPath row]];

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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
}
*/

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

@end
