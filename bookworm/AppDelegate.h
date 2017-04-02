//
//  AppDelegate.h
//  bookworm
//
//  Created by Raify Hidalgo on 4/1/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import "dbManager.h"
@import GoogleSignIn;
@import Firebase;


@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FIRDatabaseReference *dbRef;
@property (nonatomic) dbManager* dBaseManager;
@end

