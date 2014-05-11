//
//  SignUpForm.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "SignUpForm.h"

@implementation SignUpForm

- (NSArray *)fields
{
    return @[
             
             @"username",
             @"password",
             // @"phone",
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitRegistrationForm:"},
             
             ];
}

@end
