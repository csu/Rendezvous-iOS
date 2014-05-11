//
//  PhoneVerificationForm.m
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import "PhoneVerificationForm.h"

@implementation PhoneVerificationForm

- (NSArray *)fields
{
    return @[
             @"verificationCode",
             
             @{FXFormFieldTitle: @"Submit", FXFormFieldHeader: @"", FXFormFieldAction: @"submitPhoneVerificationForm:"},
             
             ];
}

@end
