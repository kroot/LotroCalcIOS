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
    @private NSString *profession;
    @private NSString *tier;
}

@property (nonatomic, retain) NSArray *recipeNames;
@property (copy) NSString *profession;
@property (copy) NSString *tier;

@end
