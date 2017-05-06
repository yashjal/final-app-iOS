//
//  AddBookViewController.h
//  bookworm
//
//  Created by Yash Jalan on 4/23/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddBookViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

@property (weak, nonatomic) IBOutlet UITextField *Author;
@property (weak, nonatomic) IBOutlet UITextField *Title;
@property (weak, nonatomic) IBOutlet UITextField *Condition;
@property (weak, nonatomic) IBOutlet UITextField *Publisher;
@property (weak, nonatomic) IBOutlet UITextField *Summary;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (weak, nonatomic) IBOutlet UITextField *lattitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) FIRStorageReference *storageRef;


@end
