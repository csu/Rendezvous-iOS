//
//  FacebookSignUpForm.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "FacebookSignUpForm.h"

@implementation FacebookSignUpForm

- (NSArray *)fields
{
    return @[
             @"username",
             @"phone",
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitFacebookSignUpForm:"},
             
             ];
}

@end
