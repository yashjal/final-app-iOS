//
//  ProfileViewController.h
//  bookworm
//
//  Created by Yash Jalan on 4/25/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (copy, nonatomic ) NSString *userEmail;


@end
