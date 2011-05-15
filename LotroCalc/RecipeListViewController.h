//
//  RecipeListViewController.h
//  LotroCalc
//
//  Created by kroot on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsListViewController.h"
#import "MBProgressHUD.h"


@interface RecipeListViewController : UITableViewController <MBProgressHUDDelegate> {
    @private NSString *profession;
    @private NSString *tier;
    
    @private NSArray *_recipeNames;
    
    IBOutlet UITableView *recipeView;
    @private IngredientsListViewController *_ingController;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSArray *recipeNames;
@property (copy) NSString *profession;
@property (copy) NSString *tier;

@property (nonatomic, retain) IBOutlet IngredientsListViewController *ingController;

@end
