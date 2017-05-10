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
    
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];
    self.errorHidden.hidden = YES; // Hidden field for when user can't sign in
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) emailPasswordSubmitted {
    if (self.emailField.text != Nil && self.passwordField.text != Nil) {
        [self checkEmailCredentialsInDB:self.emailField.text password:self.passwordField.text];
    }
}

//
-(void) checkEmailCredentialsInDB: (NSString*) email password: (NSString*) password {
    [[self.ref child:@"users"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary* dict = snapshot.value;
        NSArray* emails = [[dict allValues] valueForKey:@"email"];
        if ([emails containsObject:email]) {
            // If user's email is found in database, continue with sign in
             [self emailSignIn:email password:password];
        } else {
            NSLog(@"Error - Not in database");
            // Add Message Showing Not Signed In
            self.errorHidden.hidden = NO;
        }
    }];
}


-(void) emailSignIn: (NSString*) email password:(NSString*) password {
    [[FIRAuth auth] signInWithEmail:email
                           password:password
                         completion:^(FIRUser *user, NSError *error) {
                             if (error) {
                                 NSLog(@"%@",error.localizedDescription);
                             } else {
                                 [self animateView:@"toMain"];
                             }
                         }];
}


// Add animation to open to next view controller like opening a book
-(void) animateView:(NSString*) segueIdentifier{
    self.view.layer.anchorPoint = CGPointMake(0, 0.5);
    self.view.center  = CGPointMake(self.view.center.x - self.view.bounds.size.width / 2.0f, self.view.center.y);
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        CATransform3D d3 = CATransform3DIdentity;
        d3 = CATransform3DMakeRotation(3.141f/2.0f, 0.0f, -1.0f, 0.0f);
        d3.m34 = 0.001f;
        d3.m14 = -0.0015f;
        self.view.layer.transform = d3;
    } completion:^(BOOL finished) {
        if (finished) {
            [self performSegueWithIdentifier:segueIdentifier sender:Nil];
            
        }
    }
     ];

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
