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

- (void)viewDidLoad { // Setup Google Signin
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addGradient];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signInSilently];
    // Use Firebase authentication if user signed in correctly with Google
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

-(void) addGradient { // Add gradient to view, an orange/brown
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[(id)[UIColor brownColor].CGColor, (id)[UIColor grayColor].CGColor];
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}


// Sign out
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
