//
//  LoadingViewController.h
//  LOTRO Calc
//
//  Created by kroot on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoadingViewController : UIViewController {
    IBOutlet UIProgressView *myProgressView;
}

@property (nonatomic, retain) IBOutlet UIProgressView *myProgresView;

@end
