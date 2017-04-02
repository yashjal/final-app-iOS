//
//  dbMnager.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "dbManager.h"

@implementation dbManager

-(id) initWithRef: (FIRDatabaseReference*) dbRef {
    if (self = [super init]) {
        self.db = dbRef;
    }
    return self;
}


- (void) addUser {
    
    [[self.db child:@"users"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary* dict = snapshot.value;
        
    }];
}

-(void) toMain {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
