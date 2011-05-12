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

@implementation IngredientsListViewController

@synthesize profession;
@synthesize tier;
@synthesize recipeName;

@synthesize ingNames;
@synthesize ingQtys;
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    LotroWSLotroCalc* service = [LotroWSLotroCalc service];
    service.logging = YES;
    [service GetRecipeIngredients:self  action:@selector(GetRecipeIngredientsHandler:) recipeName:recipeName quantity:1 ];

    
    
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
     

- (void) GetRecipeIngredientsHandler: (id) value {

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
    
 	//if([value isKindOfClass:[LotroWSWebIngredient class]]) {
    NSMutableArray* result = (NSMutableArray*)value;
    NSMutableArray *newIngNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *newIngQtyArray = [[NSMutableArray alloc] init];

    for (LotroWSWebIngredient *ing in result) {
        NSLog(@"%@", ing.IngredientName);

        NSString *dec = [StringEncryption DecryptString:ing.IngredientName];
        NSLog(@"dec = %@\n", dec);
        
        [newIngNameArray addObject:dec];  
        NSString *qty = [NSString stringWithFormat:@"%d", ing.Quantity];
        [newIngQtyArray addObject:qty];       
    }	
    self.ingNames = newIngNameArray;
    self.ingQtys = newIngQtyArray;

    //}	   
    
    /*
    NSMutableArray* result = (NSMutableArray*)value;
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    
    
	NSLog(@"GetRecipeIngredients returned the value: %@", value);
    for (NSMutableString *ret in value) {
        NSLog(@"%@\n", ret);
        
        NSString *dec = [StringEncryption DecryptString:ret];
        NSLog(@"dec = %@\n", dec);
        
        [newArray addObject:dec];
    }
     */
    
    //self.ingNames = newArray;
    [self.tableView reloadData];
    //self.tableView.hidden = false;
    
    [activityView removeFromSuperview];
    self.title = @"Ingredients";    

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
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
