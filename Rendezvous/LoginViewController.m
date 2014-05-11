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
#import "MasterViewController.h"
#import "LoginFormViewController.h"
#import <FacebookSDK/FacebookSDK.h>

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
    
    // view customization
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login-bg.png"]];
    
    // facebook auth config
    self.loginView.readPermissions = @[@"public_profile", @"email"];
    
    // check to see if there's a user logged in via email
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    // authenticate user with persistent login
    if ([standardUserDefaults objectForKey:@"username"] && [standardUserDefaults objectForKey:@"encryptedPassword"]) {
        NSString *username = nil;
        NSString *encryptedPassword = nil;
        
        username = [standardUserDefaults objectForKey:@"username"];
        encryptedPassword = [standardUserDefaults objectForKey:@"encryptedPassword"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{ @"username": username,
                                      @"encrypted_password" : encryptedPassword
                                      };
        [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, @"/user/login/encrypted/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *json = ((NSDictionary *)responseObject);
            if ([json objectForKey:@"status"]) { // something went wrong
                NSLog(@"persistent login with email failed, going to fall back to auth options screen");
            }
            else { // got a user
                self.navigationController.navigationBarHidden = YES;
                [self performSegueWithIdentifier:@"PickViewSegue" sender:self];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %ld", (long)operation.response.statusCode);
        }];
    }
    
    // if we're actually going to display the page:
    // customize fbloginview
//    FBLoginView *loginview = self.fbLoginView;
//    for (id obj in loginview.subviews)
//    {
//        if ([obj isKindOfClass:[UIButton class]])
//        {
//            UIButton * loginButton =  obj;
//            UIImage *loginImage = [UIImage imageNamed:@"fb-auth-button-new.png"];
//            [loginButton setContentMode:UIViewContentModeCenter];
//            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
//            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
//            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//            // [loginButton sizeToFit];
//        }
//        if ([obj isKindOfClass:[UILabel class]])
//        {
//            UILabel * loginLabel =  obj;
//            loginLabel.text = @"";
//            // loginLabel.textAlignment = UITextAlignmentCenter;
//            // loginLabel.frame = CGRectMake(0, 0, 271, 37);
//        }
//    }
}

-(void)viewWillAppear:(BOOL)animated {
    FBLoginView *loginview = self.fbLoginView;
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"fb-auth-button-new.png"];
            [loginButton setContentMode:UIViewContentModeCenter];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            // [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
            // loginLabel.textAlignment = UITextAlignmentCenter;
            // loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }
    }
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if(self.isFirstLoginDone) {
        NSString *userFacebookId = user.id;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:[NSString stringWithFormat:@"%s%@%@", APIBaseURL, @"/user/exists/fb/", userFacebookId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *json = ((NSDictionary *)responseObject);
            
            // user does not exist already
            if ([json objectForKey:@"status"]) {
                NSLog(@"%@", json);
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                
                if (standardUserDefaults) {
                    [standardUserDefaults setObject:[NSString stringWithString:user.first_name] forKey:@"firstName"];
                    [standardUserDefaults setObject:[NSString stringWithString:user.last_name] forKey:@"lastName"];
                    [standardUserDefaults setObject:[NSString stringWithString:user.id] forKey:@"facebookId"];
                    [standardUserDefaults setObject:[NSString stringWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.id]] forKey:@"picture"];
                    [standardUserDefaults synchronize];
                }
                
                FacebookSignUpFormViewController *controller = [[FacebookSignUpFormViewController alloc] init];
                self.navigationController.navigationBarHidden = NO;
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            // user already exists, go to friends list
            else {
                // overwrite the current username in defaults just in case, because new status requires it
                NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                if (standardUserDefaults) {
                    [standardUserDefaults setObject:[json valueForKey:@"username"] forKey:@"username"];
                    [standardUserDefaults synchronize];
                }
                
                self.navigationController.navigationBarHidden = YES;
                [self performSegueWithIdentifier:@"PickViewSegue" sender:self];
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
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)loginAction:(id)sender {
    LoginFormViewController *controller = [[LoginFormViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
