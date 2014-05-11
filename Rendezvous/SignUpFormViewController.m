//
//  SignUpFormViewController.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "SignUpFormViewController.h"
#import "FXForms/FXForms.h"
#import "SignUpForm.h"
#import "AFNetworking/AFNetworking.h"
#import "Globals.h"
#import "PhoneVerificationFormViewController.h"

@interface SignUpFormViewController ()

@end

@implementation SignUpFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Sign Up"];
        self.formController.form = [[SignUpForm alloc] init];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pick-bg.png"]];
    }
    return self;
}

- (void)submitSignUpForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    SignUpForm *form = cell.field.form;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"username": form.username,
                                  @"password" : form.password,
                                  @"firstname" : form.firstName,
                                  @"lastname" : form.lastName,
                                  @"phone" : form.phone,
                                  @"picture" : @""
                                  };
    [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, @"/user/new/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // always enters success because the API returns valid JSON and doesn't have appropriate HTTP status codes
        NSInteger status = [[((NSDictionary *)responseObject) objectForKey:@"status"] intValue];
        if (status == 200) {
            // continue to text verification, pass username over
            // not the best way to pass the username over, but it'll do for the MVP
            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            
            if (standardUserDefaults) {
                [standardUserDefaults setObject:[NSString stringWithString:form.username] forKey:@"username"];
                [standardUserDefaults synchronize];
            }
            
            PhoneVerificationFormViewController *controller = [[PhoneVerificationFormViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (status == 409) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username already taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        // else if (status == 400) {
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %ld", (long)operation.response.statusCode);
    }];
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
