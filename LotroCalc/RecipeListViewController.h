//
//  RecipeListViewController.h
//  LotroCalc
//
//  Created by kroot on 5/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecipeListViewController : UITableViewController {
    @private NSArray *_recipeNames;
}

@property (nonatomic, retain) NSArray *recipeNames;

@end
