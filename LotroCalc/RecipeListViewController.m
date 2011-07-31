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
#import "MBProgressHUD.h"

@implementation RecipeListViewController

@synthesize recipeNames = _recipeNames;

@synthesize profession;
@synthesize tier;

@synthesize ingController = _ingController;


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
    
    UIBarButtonItem * newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Recipes" style:UIBarButtonItemStyleBordered target:self action:nil];
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
    NSString *encProf = [StringEncryption EncryptString: self.profession];

    service.logging = NO;
    [service GetRecipeNames:self action:@selector(GetRecipeNamesHandler:) 
                 profession: encProf 
                       tier: self.tier];
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    self.title = @"Loading...";
}

- (void) GetRecipeNamesHandler: (id) value {

    [HUD hide:YES];
    self.title = self.tier;
    
	// Handle errors
	if([value isKindOfClass:[NSError class]]) {
        
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" 
            message:value delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alert show];	
        [alert release];       
        
		return;
	}				    
    
	// Do something with the NSMutableArray* result
    NSMutableArray* result = (NSMutableArray*)value;
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    if ([result count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" 
            message:@"Unable to read recipe data" delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles: nil];
        [alert show];	
        [alert release];               
    }
        
    for (NSMutableString *ret in result) {
        
        NSString *dec = [StringEncryption DecryptString:ret];
        
        [newArray addObject:dec];
    }
    
    self.recipeNames = newArray;
    [self.tableView reloadData];    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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

//- (UITableViewCellAccessoryType) tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellAccessoryDisclosureIndicator;
//}

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
    
    _ingController = [[IngredientsListViewController alloc] init];
    
    NSUInteger row = [indexPath row];
    NSString *newText = [self.recipeNames objectAtIndex:row];
    _ingController.navigationItem.title = newText;
    
    _ingController.profession = self.profession;
    _ingController.tier = self.tier;
    _ingController.recipeName = newText;
    
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:(UITableViewController *)self.ingController animated:YES];    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}


@end
