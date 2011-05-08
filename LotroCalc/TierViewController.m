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
    self.tiers = [[NSArray alloc] initWithObjects:@"Journeyman", @"Apprentice", nil];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    
{
    NSLog(@"count=%d", [self.tiers count]);
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
    return cell;                             
}




@end
