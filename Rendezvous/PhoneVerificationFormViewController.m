//
//  PhoneVerificationFormViewController.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "PhoneVerificationFormViewController.h"
#import "PhoneVerificationForm.h"
#import "FXForms/FXForms.h"
#import "AFNetworking/AFNetworking.h"
#import "Globals.h"
#import "MasterViewController.h"

@interface PhoneVerificationFormViewController ()

@end

@implementation PhoneVerificationFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Verify Phone"];
        self.formController.form = [[PhoneVerificationForm alloc] init];
    }
    return self;
}


- (void)submitPhoneVerificationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    // we can lookup the form from the cell if we want, like this:
    PhoneVerificationForm *form = cell.field.form;
    
    // get username back
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = nil;
    
    if (standardUserDefaults)
        username = [standardUserDefaults objectForKey:@"username"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"code": form.verificationCode, @"username": username};
    [manager PUT:[NSString stringWithFormat:@"%s%@", APIBaseURL, @"/user/new/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // always enters success because the API returns valid JSON and doesn't have appropriate HTTP status codes
        NSDictionary *user = ((NSDictionary *)responseObject);
        NSLog(@"%@", user);
        if ([user objectForKey:@"status"]) {
            if ([[user objectForKey:@"status"] integerValue] == 401) {
                // later should add something to limit the number of tries
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect confirmation code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            // also later need to handle: 409 – restart registration; others – ???
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"It worked." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            
            // store the user information somewhere
            MasterViewController *controller = [[MasterViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
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
