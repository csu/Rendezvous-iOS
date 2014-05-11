//
//  LoginForm.h
//  Rendezvous
//
//  Created by Christopher Su on 5/10/14.
//  Copyright (c) 2014 Christopher Su. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms/FXForms.h"

@interface LoginForm : NSObject <FXForm>


@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
