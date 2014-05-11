//
//  FreePickerViewController.m
//  Rendezvous
//
//  Created by Christopher Su on 5/11/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "FreePickerViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"

@interface FreePickerViewController ()

@end

@implementation FreePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pick-bg.png"]];
    self.navigationController.navigationBarHidden = YES;
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

- (IBAction)browseButtonPress:(id)sender {
    
}

- (IBAction)eatPickButtonPress:(id)sender {
    
}

- (IBAction)hangoutPickButtonPress:(id)sender {
    
}

- (IBAction)moviePickButtonPress:(id)sender {
    
}

- (IBAction)studyPickButtonPress:(id)sender {
    
}

- (IBAction)logoutButtonPress:(id)sender {
    // clear stored user defaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    // clear facebook login
    [FBSession.activeSession closeAndClearTokenInformation];
    
    // go back to home screen
    [self.navigationController popToRootViewControllerAnimated:TRUE];
    
}

@end
