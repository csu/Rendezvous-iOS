//
//  LoginViewController.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "LoginViewController.h"
#import "FXForms/FXForms.h"
#import "SignUpForm.h"
#import "SignUpFormViewController.h"
#import "Globals.h"
#import "AFNetworking/AFNetworking.h"
#import "FacebookSignUpFormViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isFirstLoginDone = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginView.readPermissions = @[@"public_profile", @"email"];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if(self.isFirstLoginDone) {
        // NSLog(@"%@", user);
        NSString *userFacebookId = user.id;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"%s%@%@", APIBaseURL, @"/user/exists/fb/", userFacebookId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *json = ((NSDictionary *)responseObject);
            // NSLog(@"%@", json);
            if ([json objectForKey:@"status"]) { // user does not exist already
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                if (standardUserDefaults) {
                    [standardUserDefaults setObject:[NSString stringWithString:user.first_name] forKey:@"firstName"];
                    [standardUserDefaults setObject:[NSString stringWithString:user.last_name] forKey:@"lastName"];
                    [standardUserDefaults setObject:[NSString stringWithString:user.id] forKey:@"facebookId"];
                    [standardUserDefaults synchronize];
                }
                
                FacebookSignUpFormViewController *controller = [[FacebookSignUpFormViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else { // user already exists
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    self.isFirstLoginDone = NO;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.isFirstLoginDone = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SignUpSegue"])
    {
        
    }
}

- (IBAction)signUpAction:(id)sender {
    SignUpFormViewController *controller = [[SignUpFormViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
