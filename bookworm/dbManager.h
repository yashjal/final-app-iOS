//
//  dbMnager.h
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface dbManager : NSObject
@property (strong, nonatomic) FIRDatabaseReference* db;
-(id) initWithRef: (FIRDatabaseReference*) dbRef;
-(BOOL) checkEmailCredentialsInDB: (NSString*) email password: (NSString*) password;
-(void) emailSignIn: (NSString*) email password:(NSString*) password;
@end
