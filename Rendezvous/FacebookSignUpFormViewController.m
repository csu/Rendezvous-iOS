//
//  FacebookSignUpFormViewController.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "FacebookSignUpFormViewController.h"
#import "FacebookSignUpForm.h"
#import "FXForms/FXForms.h"
#import "AFNetworking/AFNetworking.h"
#import "Globals.h"
#import "PhoneVerificationFormViewController.h"

@interface FacebookSignUpFormViewController ()

@end

@implementation FacebookSignUpFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Sign Up"];
        self.formController.form = [[FacebookSignUpForm alloc] init];
    }
    return self;
}



- (void)submitFacebookSignUpForm:(UITableViewCell<FXFormFieldCell> *)cell
{
    //we can lookup the form from the cell if we want, like this:
    FacebookSignUpForm *form = cell.field.form;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *firstName = nil;
    NSString *lastName = nil;
    NSString *facebookId = nil;
    NSString *picture = nil;
    
    if (standardUserDefaults) {
        firstName = [standardUserDefaults objectForKey:@"firstName"];
        lastName = [standardUserDefaults objectForKey:@"lastName"];
        facebookId = [standardUserDefaults objectForKey:@"facebookId"];
        picture = [standardUserDefaults objectForKey:@"picture"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // just use facebookId as password for MVP presentation demo
    NSDictionary *parameters = @{ @"username": form.username,
                                  @"password" : facebookId,
                                  @"firstname" : firstName,
                                  @"lastname" : lastName,
                                  @"phone" : form.phone,
                                  @"picture" : picture,
                                  @"facebook_id" : facebookId
                                  };
    [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, @"/user/new/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[((NSDictionary *)responseObject) objectForKey:@"status"] intValue];
        if (status == 200) {
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
