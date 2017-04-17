//
//  MyBooksDetailViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/16/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "MyBooksDetailViewController.h"

@interface MyBooksDetailViewController ()

@end

@implementation MyBooksDetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Here");
    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDate *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

@end
