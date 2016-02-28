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
@synthesize ingTypes;
@synthesize ingsCrafted;
@synthesize ingTiers;
@synthesize ingsXp;
@synthesize ingsSupplierCost;

@synthesize ingController = _ingController;


- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
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
    NSString *encRecipeName = [StringEncryption EncryptString: self.recipeName];
    service.logging = NO;
    [service GetRecipeIngredients:self  action:@selector(GetRecipeIngredientsHandler:) recipeName:encRecipeName quantity:1 ];    
    
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
    
    NSMutableArray *newIngNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngQtyArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngTypeArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngCraftedArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngTierArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngXpArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngSupplierCostArray = [[NSMutableArray alloc] init];
    

    for (LotroWSWebIngredient *ing in result) {
        //NSLog(@"%@", ing.IngredientName);

        NSString *decName = [StringEncryption DecryptString:ing.IngredientName];
        //NSLog(@"dec = %@\n", dec);
        [newIngNameArray addObject:decName];  
        
        NSString *qty = [@"Quantity: " stringByAppendingFormat:@"%d", ing.Quantity];
        [newIngQtyArray addObject:qty];       
        
        NSString *decType = [@"Ingredient Type: " stringByAppendingFormat:@"%@", [StringEncryption DecryptString:ing.IngredientType]];
        //NSLog(@"dec = %@\n", dec);
        [newIngTypeArray addObject:decType];  
        
        if (ing.IsCrafted)
            [newIngCraftedArray addObject:@"True"];  
        else
            [newIngCraftedArray addObject:@"False"];        
        
        if([ing Tier] != nil)
        {
            NSString *decTier = [@"Tier: " stringByAppendingFormat:@"%@", [StringEncryption DecryptString:ing.Tier]];
            [newIngTierArray addObject:decTier];
        }
        else
            [newIngTierArray addObject:@""];            
        
        NSString *xp = [@"Crafting XP: " stringByAppendingFormat:@"%d", ing.Xp];
        [newIngXpArray addObject:xp];
        
        
        NSString *cost = [@"Cost: " stringByAppendingFormat:@"%ld", ing.SupplierCost];
        [newIngSupplierCostArray addObject:cost];       
        
    }	
    self.ingNames = newIngNameArray;
    self.ingQtys = newIngQtyArray;
    self.ingTypes = newIngTypeArray;
    self.ingTiers = newIngTierArray;
    self.ingsCrafted = newIngCraftedArray;
    self.ingsXp = newIngXpArray;
    self.ingsSupplierCost = newIngSupplierCostArray;
    

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
    if (0 == [self.ingNames count])
        return 0;
    
    // Return the number of sections.
    return [self.ingNames count] + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == [self.ingNames count])
        return 0;
    
    if(section == [self.ingNames count])
        return 1;
    
    NSString *isCrafted = [self.ingsCrafted objectAtIndex:section];
    if([isCrafted isEqualToString: @"True"])
        return 4;
    else
    {
        NSString *cost = [self.ingsSupplierCost objectAtIndex:section];
        if ([cost isEqualToString: @"Cost: 0"])
            return 2;

        return 3;
    }
    
//    if (section == 0)
//    // Return the number of rows in the section.
//        return [self.ingNames count];
//    else
//        return 1;
}


/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == [self.ingNames count])
        return @"";

    if(section == [self.ingNames count])
        return @"Materials Breakdown";
    
    return [self.ingNames objectAtIndex:section];

//    if(section == 0)
//        return @"Required Ingredients";
//    else
//        return @"all";
}
 */

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
   
    NSString *sectionTitle;
    if (0 == [self.ingNames count])
        sectionTitle = @"";
    
    else if(section == [self.ingNames count])
        sectionTitle = @"Materials Breakdown";
    
    else
        sectionTitle =  [self.ingNames objectAtIndex:section];
    
    
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
    [label release];
    
    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    if (indexPath == nil)
        return cell;    
    
    NSUInteger secNum = [indexPath section];
    
    //if ([indexPath section] == nil)
      //  return cell;
    
    //NSLog(@"section = %@\n", sec);
   

    
    //if (sec == nil)
      //  return cell;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;

 
    if (secNum < [self.ingNames count])
    {
        
        NSString *isCrafted = [self.ingsCrafted objectAtIndex:secNum];
        int rowNum = indexPath.row;
        
        if([isCrafted isEqualToString: @"True"])
        {
            if(0 == rowNum)
            {
                cell.selectionStyle = UITableViewCellSelectionStyleBlue; 
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = [self.ingTypes objectAtIndex: secNum];                
            }
            else if (1 == rowNum)
            {
                cell.textLabel.text = [self.ingQtys objectAtIndex:secNum]; 
            }
            else if (2 == rowNum)
            {
                cell.textLabel.text = [self.ingTiers objectAtIndex:secNum];
            }
            else if (3 == rowNum)
            {
                cell.textLabel.text = [self.ingsXp objectAtIndex:secNum];
            }

        }
        else
        {
            if(0 == rowNum)
            {
                cell.textLabel.text = [self.ingTypes objectAtIndex:secNum];
            }
            else if (1 == rowNum)
            {
                cell.textLabel.text = [self.ingQtys objectAtIndex:secNum];
            }
            else if (2 == rowNum)
            {
                cell.textLabel.text = [self.ingsSupplierCost objectAtIndex:secNum];
            }
        }
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Show all required mats";        
    }
    
//    if(indexPath.section == 0)
//    {
//        
//        cell.textLabel.text = [self.ingNames objectAtIndex:[indexPath row]];
//        cell.detailTextLabel.text = [self.ingQtys objectAtIndex:[indexPath row]];                
//    }
//    else
//    {
//        cell.textLabel.text = @"Show required mats";
//    }
    
    //cell.textLabel.text = [self.ingNames objectAtIndex:[indexPath row]];
    //cell.detailTextLabel.text = [self.ingQtys objectAtIndex:[indexPath row]];

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
    /*
    // Navigation logic may go here. Create and push another view controller.
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */

    NSUInteger secNum = [indexPath section];
    
    if (secNum < [self.ingNames count])
    {    
        
        NSString *isCrafted = [self.ingsCrafted objectAtIndex:secNum];
        int rowNum = indexPath.row;
        
        if([isCrafted isEqualToString: @"True"])
        {
            if(0 == rowNum)
            {                
                NSString *newText = [self.ingNames objectAtIndex:secNum];
                
                _ingController = [[ComponentIngredientListView alloc] init];
                
                //NSUInteger row = [indexPath row];
                
                _ingController.navigationItem.title = newText;
                
                _ingController.profession = self.profession;
                _ingController.tier = self.tier;
                _ingController.recipeName = self.recipeName;
                _ingController.compIngName = newText;
                
                // Pass the selected object to the new view controller.
                [self.navigationController pushViewController:(UITableViewController *)self.ingController animated:YES];    
           }
        }
        

        
//        
//        // Pass the selected object to the new view controller.
//        [self.navigationController pushViewController:(UITableViewController *)self.ingController animated:YES];    
    }
    else
    {
//        NSMutableArray *ingreds = [[NSMutableArray alloc] init];
//        for (int i=0; i < [self.ingNames count]; i++) {
//            NSString *ingName = [self.ingNames objectAtIndex:i];
//            NSString *encIngName = [StringEncryption EncryptString: ingName];
//            [ingreds addObject:encIngName];
//        }
        
        _ingController = [[RecursiveIngredientsListView alloc] init];
        
        //NSUInteger row = [indexPath row];
        
        _ingController.navigationItem.title = [self recipeName];
        
        _ingController.profession = self.profession;
        _ingController.tier = self.tier;
        _ingController.recipeName = self.recipeName;
        //_ingController.ingNames = ingreds;
        //_ingController.ingQtys = 
        
        
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:(UITableViewController *)self.ingController animated:YES];    
    }
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
