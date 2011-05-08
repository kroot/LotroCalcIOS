//
//  RootViewController.h
//  LotroCalc
//
//  Created by kroot on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TierViewController;

@interface RootViewController : UITableViewController <UITabBarDelegate, UITableViewDataSource> 
{
    NSArray *_Professions;
    TierViewController *tierController;
}

@property (nonatomic, retain) NSArray *Professions;
@property (nonatomic, retain) IBOutlet TierViewController *tierController;

@end
