//
//  LoginViewController.h
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

- (IBAction)signUpAction:(id)sender;

@end
