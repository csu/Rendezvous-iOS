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

@property (nonatomic) BOOL isFirstLoginDone;

// to configure permissions for facebook login:
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)signUpAction:(id)sender;
- (IBAction)loginAction:(id)sender;

@end
