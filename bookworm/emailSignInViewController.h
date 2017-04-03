//
//  emailSignInViewController.h
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface emailSignInViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UILabel *errorHidden;
-(void) checkEmailCredentialsInDB: (NSString*) email password: (NSString*) password;
@end
