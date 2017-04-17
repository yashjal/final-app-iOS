//
//  BookListings.h
//  bookworm
//
//  Created by Yash Jalan on 4/15/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface BookListings : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end
