//
//  IngredientsListViewController.h
//  LOTRO Calc
//
//  Created by kroot on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ComponentIngredientListView.h"
#import "RecursiveIngredientsListView.h"


@interface IngredientsListViewController : UITableViewController <MBProgressHUDDelegate> {
    @private NSString *profession;
    @private NSString *tier;
    @private NSString *recipeName;
    
    @private NSArray *ingNames;
    @private NSArray *ingQtys;
    IBOutlet UITableView *ingredientView;    

    MBProgressHUD *HUD;
}


@property (copy) NSString *profession;
@property (copy) NSString *tier;
@property (copy) NSString *recipeName;

@property (nonatomic, retain) NSArray *ingNames;
@property (nonatomic, retain) NSArray *ingQtys;
@property (nonatomic, retain) NSArray *ingTypes;
@property (nonatomic, retain) NSArray *ingsCrafted;
@property (nonatomic, retain) NSArray *ingTiers;
@property (nonatomic, retain) NSArray *ingsXp;
@property (nonatomic, retain) NSArray *ingsSupplierCost;

//@property (nonatomic, retain) UIView *activityView;
@property (nonatomic, retain) IBOutlet ComponentIngredientListView *ingController;


@end
