//
//  MasterViewController.h
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
