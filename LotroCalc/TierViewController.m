//
//  TierViewController.m
//  LotroCalc
//
//  Created by kroot on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TierViewController.h"


@implementation TierViewController

@synthesize tiers = Tiers;
@synthesize recipeListViewController = _recipeListViewController;
@synthesize profession;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated 
{
    self.tiers = [[NSMutableArray alloc] initWithObjects:
                  @"Apprentice", 
                  @"Journeyman", 
                  @"Expert",
                  @"Artisan",
                  @"Master",
                  @"Supreme",
                  nil
                  ];
    
    //[super viewWillAppear:<#animated#>];
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [tiers release];
}

- (void)dealloc
{
    [Tiers release];

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
    self.tiers = nil;
    
    // Do any additional setup after loading the view from its nib.
    //self.title = self.profession;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    
{
    return [self.tiers count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
                             
    cell.textLabel.text = [self.tiers objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;                             
}


//- (UITableViewCellAccessoryType) tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellAccessoryDisclosureIndicator;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //[<#DetailViewController#>] *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    //[self.navigationController pushViewController:self.tierController animated:YES];

    _recipeListViewController = [[RecipeListViewController alloc] init];
    
    NSUInteger row = [indexPath row];
    NSString *newText = [Tiers objectAtIndex:row];
    _recipeListViewController.navigationItem.title = newText;
    
    _recipeListViewController.profession = self.profession;
    _recipeListViewController.tier = newText;


    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:(UITableViewController *)self.recipeListViewController animated:YES];

	
}




@end
