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

@interface PhoneVerificationFormViewController ()

@end

@implementation PhoneVerificationFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Sign Up"];
        self.formController.form = [[PhoneVerificationForm alloc] init];
    }
    return self;
}


- (void)submitPhoneVerificationForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    PhoneVerificationForm *form = cell.field.form;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"code": form.verificationCode, @"username": @"INSERT_USERNAME_HERE_SOMEHOW"};
    [manager POST:@"http://140.142.143.133/user/new/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // always enters success because the API returns valid JSON and doesn't have appropriate HTTP status codes
        NSInteger status = [[((NSDictionary *)responseObject) objectForKey:@"status"] intValue];
        if (status == 200) {
            // continue to text verification
            
        }
        else if (status == 409) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username/email already taken." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
