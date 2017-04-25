//
//  emailSignInViewController.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "emailSignInViewController.h"
@import Firebase;
@interface emailSignInViewController ()

@end

@implementation emailSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGradient];
    
    // Do any additional setup after loading the view.
     self.ref = [[FIRDatabase database] reference];
    self.errorHidden.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) emailPasswordSubmitted {
    NSLog(@"1");
    if (self.emailField.text != Nil && self.passwordField.text != Nil) {
         NSLog(@"2");
        [self checkEmailCredentialsInDB:self.emailField.text password:self.passwordField.text];
    }
}

-(void) checkEmailCredentialsInDB: (NSString*) email password: (NSString*) password {
    NSLog(@"3");
    [[self.ref child:@"users"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"4");
        NSDictionary* dict = snapshot.value;
        NSLog(@"5");
        NSArray* emails = [[dict allValues] valueForKey:@"email"];
        NSLog(@"6");
        if ([emails containsObject:email]) {
            NSLog(@"7");
             [self emailSignIn:email password:password];
        } else {
            NSLog(@"8");
            NSLog(@"Error - Not in database");
            // Add Message Showing Not Signed In
            self.errorHidden.hidden = NO;
        }
    }];
}


-(void) emailSignIn: (NSString*) email password:(NSString*) password {
    NSLog(@"6");
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             if (error) {
                                 NSLog(@"%@",error.localizedDescription);
                             } else {
                             NSLog(@"7 - Signed in ");
                             [self performSegueWithIdentifier:@"toMain" sender:Nil];
                             }
                         }];
}

-(void) addGradient {
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor grayColor].CGColor, (id)[UIColor blackColor].CGColor];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
