//
//  SignInViewController.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "SignInViewController.h"
@import Firebase;
@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
    [[FIRAuth auth]
                   addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth, FIRUser *_Nullable user) {
                       if (user) {
                           [self performSegueWithIdentifier:@"segueToMain" sender:nil];
                        // Google Sign In Success
                       }
                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Sign out
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
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
