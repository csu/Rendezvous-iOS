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
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking/AFNetworking.h"
#import "Globals.h"

@interface FreePickerViewController () {
    CLLocationManager *locationManager;
}

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
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pick-bg.png"]];
    self.navigationController.navigationBarHidden = YES;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary*)getLocation {
    NSArray *keys = [NSArray arrayWithObjects:@"lat", @"long", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", locationManager.location.coordinate.latitude], [NSString stringWithFormat:@"%f", locationManager.location.coordinate.longitude], nil];
    NSDictionary *coordinates = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSLog(@"%@", coordinates);
    return coordinates;
}

- (void)segueToFriendsList {
    self.navigationController.navigationBarHidden = NO;
    [self performSegueWithIdentifier:@"ButtonsToListSegue" sender:self];
}

- (void)postStatus:(NSString *)type {
    // get coordinates
    NSDictionary *coordinates = [self getLocation];
    
    //get username
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = nil;
    if (standardUserDefaults)
        username = [standardUserDefaults objectForKey:@"username"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{ @"username": username,
                                  @"type" : type,
                                  @"location_lat" : [coordinates valueForKey:@"lat"],
                                  @"location_lon" : [coordinates valueForKey:@"long"]
                                  };
    [manager POST:[NSString stringWithFormat:@"%s%@", APIBaseURL, @"/status/new/"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = operation.response.statusCode;
        if (status == 200) {
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Something is wrong." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Status code: %ld", (long)operation.response.statusCode);
    }];
    
}

- (IBAction)browseButtonPress:(id)sender {
    [self segueToFriendsList];
}

- (IBAction)eatPickButtonPress:(id)sender {
    [self postStatus:@"Eat"];
    
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
