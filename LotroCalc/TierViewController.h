//
//  TierViewController.h
//  LotroCalc
//
//  Created by kroot on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeListViewController.h"

@interface TierViewController : UITableViewController {
    @private NSArray *Tiers;
    @private RecipeListViewController *_recipeListViewController;
    @private NSString *profession;
}

@property (nonatomic, retain) NSArray *tiers;
@property (nonatomic, retain) IBOutlet RecipeListViewController *recipeListViewController;
@property (copy) NSString *profession;


@end
