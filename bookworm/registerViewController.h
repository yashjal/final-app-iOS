//
//  registerViewController.h
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@import Firebase;
@interface registerViewController : ViewController
@property (weak, nonatomic) IBOutlet UITextField *regUsername;
@property (weak, nonatomic) IBOutlet UITextField *regEmail;
@property (weak, nonatomic) IBOutlet UITextField *regPwd;
@end
