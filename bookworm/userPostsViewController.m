//
//  userPostsViewController.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/27/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "userPostsViewController.h"

@interface userPostsViewController ()

@end

@implementation userPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)submitPost:(id)sender {
    NSLog(@"%@",self.currentPostField.text);
}

-(void) viewWillAppear:(BOOL)animated {
    self.ref = [[FIRDatabase database] reference];
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        [[_ref child:@"users"]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            // Get user value
            NSDictionary *userDict = snapshot.value;
            NSString* idKey;
            NSMutableArray* allPosts = [[NSMutableArray alloc]init];
            for (NSString* key in userDict) {
                if ([userDict[key] containsObject:user.email]) {
                    idKey = key;
                }
                if ([userDict[key] objectForKey:@"posts"]) {
                    NSDictionary* userPosts =[userDict[key] objectForKey:@"posts"];
                    for (NSString* pk in userPosts) {
                        NSString* message =[userPosts objectForKey:pk];
                        NSString* time = pk;
                        NSString* username = [userDict[key] objectForKey:@"username"];
                        NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
                        [data setObject:username forKey:@"username"];
                        [data setObject:message forKey:@"message"];
                        [allPosts addObject:data];
                    }
                }
            }
            NSLog(@"%lu", [allPosts count]);
            [self handlePosts:allPosts];
            
            self.usernameLabel.text = [NSString stringWithFormat:@"%@", [userDict[idKey] objectForKey:@"username"]];
            
            
            // ...
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }

}

-(void) handlePosts:(NSMutableArray*) posts {
     NSLog(@"Here");
    UIScrollView* scrollView = self.scroll;
    scrollView.bouncesZoom = YES;
    scrollView.backgroundColor = [UIColor grayColor];
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [scrollView addSubview:containerView];
    CGFloat maximumWidth = 0.0;
    CGFloat totalHeight = 0.0;
     NSLog(@"Here 2");
    for (int i = 0; i < [posts count]; i++) {
        CGRect frame = CGRectMake(0, totalHeight, 100, 100);
        UITextView* tview = [[UITextView alloc] initWithFrame:frame];
        NSLog(@"Here 3");
        tview.text = @"RANOD";
        tview.textColor = [UIColor whiteColor];
        tview.backgroundColor = [UIColor greenColor];
        [containerView addSubview:tview];
        
        
        // Increment our maximum width & total height
        maximumWidth = MAX(maximumWidth, tview.contentSize.width);
        totalHeight += tview.contentSize.height;
    }
    // Size the container view to fit. Use its size for the scroll view's content size as well.
    containerView.frame = CGRectMake(0, 0, maximumWidth, totalHeight);
    scrollView.contentSize = containerView.frame.size;
    
    // Minimum and maximum zoom scales
    scrollView.minimumZoomScale = scrollView.frame.size.width / maximumWidth;
    scrollView.maximumZoomScale = 4.0;
    
    
    
    
    
//    for (NSString* time in posts) {
        
 //   }
}


- (IBAction)signOutPressed:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    NSLog(@"Logged Out");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
