//
//  RootViewController.h
//  LotroCalc
//
//  Created by kroot on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UITabBarDelegate, UITableViewDataSource> 
{
    NSArray *_Professions;
}

    @property (nonatomic, retain) NSArray *Professions;

@end
