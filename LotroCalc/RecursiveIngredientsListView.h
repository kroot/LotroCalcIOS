//
//  RecursiveIngredientsListView.h
//  LOTRO Calc
//
//  Created by kroot on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RecursiveIngredientsListView : UITableViewController <MBProgressHUDDelegate> {
    
    @private NSString *profession;
    @private NSString *tier;
    @private NSString *recipeName;
        
    @private NSArray *ingNames;
    @private NSArray *ingQtys;
    
    @private NSArray *CraftedIngs;
    @private NSArray *GatheredIngs;
    @private NSArray *VendorIngs;
    
    @private NSInteger CraftedPanel;
    @private NSInteger GatheredPanel;
    @private NSInteger VendorPanel;
    @private NSInteger PanelCount;
    
    
    IBOutlet UITableView *ingredientView;    
    
    MBProgressHUD *HUD;
}

@property (copy) NSString *profession;
@property (copy) NSString *tier;
@property (copy) NSString *recipeName;

@property (nonatomic, retain) NSArray *CraftedIngs;
@property (nonatomic, retain) NSArray *GatheredIngs;
@property (nonatomic, retain) NSArray *VendorIngs;

@property NSInteger CraftedPanel;
@property NSInteger GatheredPanel;
@property NSInteger VendorPanel;
@property NSInteger PanelCount;



@end
