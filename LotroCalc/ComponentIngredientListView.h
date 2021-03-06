//
//  ComponentIngredientListView.h
//  LOTRO Calc
//
//  Created by kroot on 7/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ComponentIngredientListView : UITableViewController <MBProgressHUDDelegate> {

    @private NSString *profession;
    @private NSString *tier;
    @private NSString *recipeName;
    @private NSString *compIngName;

    @private NSArray *ingNames;
    @private NSArray *ingQtys;
    
    IBOutlet UITableView *ingredientView;    

    MBProgressHUD *HUD;
}

@property (copy) NSString *profession;
@property (copy) NSString *tier;
@property (copy) NSString *recipeName;
@property (copy) NSString *compIngName;

@property (nonatomic, retain) NSArray *ingNames;
@property (nonatomic, retain) NSArray *ingQtys;
@property (nonatomic, retain) NSArray *ingTypes;
@property (nonatomic, retain) NSArray *ingsCrafted;
@property (nonatomic, retain) NSArray *ingTiers;
@property (nonatomic, retain) NSArray *ingsXp;
@property (nonatomic, retain) NSArray *ingsSupplierCost;

@end
