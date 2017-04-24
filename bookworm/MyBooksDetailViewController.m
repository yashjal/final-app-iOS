//
//  MyBooksDetailViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/16/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "MyBooksDetailViewController.h"

@interface MyBooksDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookSummary;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPublisher;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UILabel *bookCondition;


@end

@implementation MyBooksDetailViewController

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //NSLog(@"Here");

    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    //self.navigationItem.leftBarButtonItem = backButton;

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

- (void)setBook:(NSString *)title author:(NSString *)auth publisher:(NSString *)publ
      condition:(NSString *)cond summary:(NSString *)s {
    
    if (![self.bookTitle.text isEqualToString:title] ||  ![self.bookAuthor.text isEqualToString:auth] || ![self.bookPublisher.text isEqualToString:publ] ||
        ![self.bookCondition.text isEqualToString:cond]) {
        self.bookTitle.text = title;
        self.bookAuthor.text = auth;
        self.bookCondition.text = cond;
        self.bookSummary.text = s;
        self.bookPublisher.text = publ;
    }
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
