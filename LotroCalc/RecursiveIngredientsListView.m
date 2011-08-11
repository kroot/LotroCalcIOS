//
//  RecursiveIngredientsListView.m
//  LOTRO Calc
//
//  Created by kroot on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecursiveIngredientsListView.h"
#import "LotroWSServices.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "StringEncryption.h"
#import "MBProgressHUD.h"

@implementation RecursiveIngredientsListView

@synthesize profession;
@synthesize tier;
@synthesize recipeName;

@synthesize CraftedIngs;
@synthesize GatheredIngs;
@synthesize VendorIngs;

@synthesize CraftedPanel;
@synthesize GatheredPanel;
@synthesize VendorPanel;
@synthesize PanelCount;


- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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
    NSString *encRecipeName = [StringEncryption EncryptString: self.recipeName];
    service.logging = NO;
    [service GetRecursiveIngredients:self  action:@selector(GetRecurseIngredientsHandler:) recipeName:encRecipeName quantity:1 ];    
    
    [super viewWillAppear:animated];
    
    self.title = @"Loading...";
}


- (void) GetRecurseIngredientsHandler: (id) value {
    
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
//    NSMutableArray *newIngNameArray = [[NSMutableArray alloc] init];
//    NSMutableArray *newIngQtyArray = [[NSMutableArray alloc] init];
//    NSMutableArray *newIngTypeArray = [[NSMutableArray alloc] init];
//    NSMutableArray *newIngCraftedArray = [[NSMutableArray alloc] init];
//    NSMutableArray *newIngTierArray = [[NSMutableArray alloc] init];
//    NSMutableArray *newIngXpArray = [[NSMutableArray alloc] init];
//    NSMutableArray *newIngSupplierCostArray = [[NSMutableArray alloc] init];

    NSMutableArray *newCraftedIngsArray = [[NSMutableArray alloc] init];
    NSMutableArray *newGatheredIngsArray = [[NSMutableArray alloc] init];
    NSMutableArray *newVendorIngsArray = [[NSMutableArray alloc] init];

    if ([result count] == 0)
    {
        return;
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" 
                                                        message:@"Unable to read recipe data" delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];	
        [alert release]; 
         */
    }
    
    for (LotroWSWebIngredient *ing in result) {
        
        ing.IngredientType = [StringEncryption DecryptString:ing.IngredientType];
        ing.IngredientName = [StringEncryption DecryptString:ing.IngredientName];
        ing.Tier = [StringEncryption DecryptString:ing.Tier];
        
  
        if(ing.IsCrafted)
            [newCraftedIngsArray addObject:ing];
        
        else if([ing.IngredientType isEqualToString:@"Supplier"] || 
               [ing.IngredientType isEqualToString:@"Vendor"])
                    [newVendorIngsArray addObject:ing];               
        else
            [newGatheredIngsArray addObject:ing];
           
        
    }	
    
    self.CraftedIngs = newCraftedIngsArray;
    self.GatheredIngs = newGatheredIngsArray;
    self.VendorIngs = newVendorIngsArray;
    
    NSInteger pnlCount = 0;
    CraftedPanel = -1;
    GatheredPanel = -1;
    VendorPanel = -1;
    
    if ([CraftedIngs count] > 0)
        CraftedPanel = pnlCount++;
    
    if ([GatheredIngs count] > 0)
        GatheredPanel = pnlCount++;
    
    if ([VendorIngs count] > 0)
        VendorPanel = pnlCount++;
    
    PanelCount = pnlCount;
    
    
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
    return PanelCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CraftedPanel)
    {
        return [CraftedIngs count];
    }
    else if (section == GatheredPanel)
    {
        return [GatheredIngs count];
    }
    else if (section == VendorPanel)
    {
        return [VendorIngs count];
    }
    return 0;
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CraftedPanel)
    {
        return @"Crafted Ingredients";
    }
    else if (section == GatheredPanel)
    {
        return @"Gathered Ingredients";
    }
    else if (section == VendorPanel)
    {
        return @"Vendor Ingredients";
    }
    return @"";
}
*/


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    NSString *sectionTitle;
    if (section == CraftedPanel)
        sectionTitle = @"Crafted Ingredients";
    
    else if (section == GatheredPanel)
        sectionTitle = @"Gathered Ingredients";
    
    else if (section == VendorPanel)
        sectionTitle =  @"Vendor Ingredients";
    else
    sectionTitle = @"";
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = sectionTitle;
    
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textColor = [UIColor blackColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:20];
	label.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"recurseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath == nil)
        return cell;    
    
    NSUInteger secNum = [indexPath section];
    int rowNum = indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (secNum == CraftedPanel)
    {
        LotroWSWebIngredient *ing = [self.CraftedIngs objectAtIndex: rowNum];
        cell.textLabel.text = ing.IngredientName; 
        
        NSString *subtitle = 
            [@"Quantity: " stringByAppendingFormat:@"%d - Tier: ", ing.Quantity];
        subtitle = 
            [subtitle stringByAppendingString: ing.Tier];
        
        cell.detailTextLabel.text = subtitle;
    }
    else if (secNum == GatheredPanel)
    {
        LotroWSWebIngredient *ing = [self.GatheredIngs objectAtIndex: rowNum];
        cell.textLabel.text = ing.IngredientName; 
        
        NSString *subtitle = 
            [@"Quantity: " stringByAppendingFormat:@"%d", ing.Quantity];
         
        cell.detailTextLabel.text = subtitle;            
    }
    else if (secNum == VendorPanel)
    {
        LotroWSWebIngredient *ing = [self.VendorIngs objectAtIndex: rowNum];
        cell.textLabel.text = ing.IngredientName; 
        
        NSString *subtitle = 
            [@"Quantity: " stringByAppendingFormat:@"%d - Cost: ", ing.Quantity];
        subtitle = 
            [subtitle stringByAppendingFormat:@"%d", ing.SupplierCost];
        
        cell.detailTextLabel.text = subtitle;             
    }
    
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

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

@end
