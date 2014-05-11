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
#import "MasterViewController.h"

@interface LoginFormViewController ()

@end

@implementation LoginFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Login"];
        self.formController.form = [[LoginForm alloc] init];
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
