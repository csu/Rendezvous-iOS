//
//  LoginFormViewController.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "LoginFormViewController.h"
#import "LoginForm.h"
#import "AFNetworking/AFNetworking.h"
#import "Globals.h"
#import "FreePickerViewController.h"

// Google Analytics
#import <GAI.h>
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface LoginFormViewController ()

@end

@implementation LoginFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Login"];
        self.formController.form = [[LoginForm alloc] init];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pick-bg.png"]];
    }
    return self;
}


- (void)submitLoginForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    LoginForm *form = cell.field.form;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"username": form.username,
                                  @"password" : form.password
                                  };
    [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, @"/user/login/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *json = ((NSDictionary *)responseObject);
        if ([json objectForKey:@"status"]) {
            // login failed, show error messages according to the three different error statuses
        }
        else { // got a user object
            // save the received username and encrypted password for persistent login
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            
            if (standardUserDefaults) {
                [standardUserDefaults setObject:[json objectForKey:@"username"] forKey:@"username"];
                [standardUserDefaults setObject:[json objectForKey:@"password"] forKey:@"encryptedPassword"];
                [standardUserDefaults synchronize];
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            FreePickerViewController *controller = (FreePickerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"FreePicker"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %ld", (long)operation.response.statusCode);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Google Analytics
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:@"Login Form"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
