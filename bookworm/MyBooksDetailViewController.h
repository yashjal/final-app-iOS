//
//  MyBooksDetailViewController.h
//  bookworm
//
//  Created by Yash Jalan on 4/16/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBooksDetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;

- (void)setBook:(NSString *)title author:(NSString *)auth publisher:(NSString *)publ
      condition:(NSString *)cond summary:(NSString *)s;

@end
