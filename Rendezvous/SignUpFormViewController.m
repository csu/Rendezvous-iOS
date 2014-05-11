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
    }
    return self;
}

- (void)submitSignUpForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    SignUpForm *form = cell.field.form;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"username": form.username, @"password" : form.password, @"firstname" : form.firstName, @"lastname" : form.lastName, @"email" : form.email, @"phone" : form.phone, @"picture" : @""};
    [manager POST:@"http://140.142.143.133/user/new/" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
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
