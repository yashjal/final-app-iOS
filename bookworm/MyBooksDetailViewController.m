//
//  MyBooksDetailViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/16/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "MyBooksDetailViewController.h"
#import "ProfileViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MyBooksDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookSummary;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthor;
@property (weak, nonatomic) IBOutlet UILabel *bookPublisher;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UILabel *bookCondition;
@property (weak, nonatomic) IBOutlet UILabel *bookUser;
@property (strong, nonatomic) IBOutlet UIImageView *bookImage;


@end

@implementation MyBooksDetailViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

//the segue in the prev. view controller sets all the info of the book selected
- (void)setBook:(NSString *)title author:(NSString *)auth publisher:(NSString *)publ
      condition:(NSString *)cond summary:(NSString *)s user:(NSString *)u{
    
    if (![self.bookTitle.text isEqualToString:title] ||  ![self.bookAuthor.text isEqualToString:auth] || ![self.bookPublisher.text isEqualToString:publ] ||
        ![self.bookCondition.text isEqualToString:cond]) {
        self.bookTitle.text = title;
        self.bookAuthor.text = auth;
        self.bookCondition.text = cond;
        self.bookSummary.text = s;
        self.bookPublisher.text = publ;
        self.bookUser.text = u;
        
    }
}

//the segue in the prev. view controller sets the image of the book selected
-(void)setImage:(UIImage *)image {
    self.bookImage.image = image;
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"page-flip-02" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //set emailId of the user who owns this book
    ProfileViewController *controller = (ProfileViewController *)[segue destinationViewController];
    controller.userEmail = self.bookUser.text;
    
    //sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"page-flip-01a" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
}


@end
