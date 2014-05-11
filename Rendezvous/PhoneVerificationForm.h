//
//  PhoneVerificationForm.h
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms/FXForms.h"

@interface PhoneVerificationForm : NSObject <FXForm>

@property (nonatomic, copy) NSString *verificationCode;

@end
