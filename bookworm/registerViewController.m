//
//  registerViewController.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "registerViewController.h"
#include <CommonCrypto/CommonDigest.h>

@interface registerViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add description of error if registration is not good

- (IBAction)register:(id)sender { // Make sure all registration fields are filled
    if (self.regUsername.text != Nil && self.regEmail != Nil && self.regPwd != Nil) {
        [[FIRAuth auth] createUserWithEmail:self.regEmail.text
                               password:self.regPwd.text
                             completion:^(FIRUser *user, NSError *error) {
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                 } else {
                                     
                                 NSLog(@"User Registered");

                                 NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
                                [data setObject:self.regUsername.text forKey:@"username"];
                                [data setObject:self.regEmail.text forKey:@"email"];
                                 [[[_ref child:@"users"] childByAutoId] setValue:data];
                                 [self performSegueWithIdentifier:@"regToMain" sender:Nil];
                                 }
                             }];
    }
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
