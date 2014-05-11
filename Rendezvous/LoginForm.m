//
//  LoginForm.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "LoginForm.h"

@implementation LoginForm

- (NSArray *)fields
{
    return @[
             @"username",
             @"password",
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitLoginForm:"},
             
             ];
}

@end
