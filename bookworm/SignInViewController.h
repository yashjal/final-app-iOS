//
//  SignInViewController.h
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <Google/SignIn.h>

@interface SignInViewController : ViewController <GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@end
