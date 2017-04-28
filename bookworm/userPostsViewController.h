//
//  userPostsViewController.h
//  bookworm
//
//  Created by Raify Hidalgo on 4/27/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface userPostsViewController : ViewController
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *currentPostField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end
