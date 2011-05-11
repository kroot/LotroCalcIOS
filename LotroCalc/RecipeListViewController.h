//
//  RecipeListViewController.h
//  LotroCalc
//
//  Created by kroot on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsListViewController.h"


@interface RecipeListViewController : UITableViewController {
    @private NSString *profession;
    @private NSString *tier;
    //@private NSString *recipeName;
    
    @private NSArray *_recipeNames;
    
    IBOutlet UITableView *recipeView;
    @private IngredientsListViewController *_ingController;
}

@property (nonatomic, retain) NSArray *recipeNames;
@property (copy) NSString *profession;
@property (copy) NSString *tier;
//@property (copy) NSString *recipeName;

@property (nonatomic, retain) UIView *activityView;
@property (nonatomic, retain) IBOutlet IngredientsListViewController *ingController;

@end
