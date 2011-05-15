//
//  IngredientsListViewController.h
//  LOTRO Calc
//
//  Created by kroot on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IngredientsListViewController : UITableViewController {
    @private NSString *profession;
    @private NSString *tier;
    @private NSString *recipeName;
    
    @private NSArray *ingNames;
    @private NSArray *ingQtys;
    IBOutlet UITableView *ingredientView;    
}


@property (copy) NSString *profession;
@property (copy) NSString *tier;
@property (copy) NSString *recipeName;

@property (nonatomic, retain) NSArray *ingNames;
@property (nonatomic, retain) NSArray *ingQtys;

@property (nonatomic, retain) UIView *activityView;

@end
