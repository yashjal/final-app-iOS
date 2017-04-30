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
    self.ref = [[FIRDatabase database] reference];
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user) {
        [[_ref child:@"users"]observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *currUserDict = snapshot.value;
            NSString* userID;
            for (NSString* key in currUserDict) {
                if ([[currUserDict[key] objectForKey:@"email"] isEqualToString:user.email]) {
                    userID = key;
                    NSLog(@"User Found");
                }
            }
            NSMutableDictionary* posts;
            if ([currUserDict[userID] objectForKey:@"posts"] != Nil) {
                posts = [currUserDict[userID] objectForKey:@"posts"];
                NSLog(@"User has post");
            } else {
                posts = [[NSMutableDictionary alloc] init];
                NSLog(@"User No Post");
            }
            NSString* inputTime = [self getDate];
            NSLog(@"Time: %@", inputTime);
            [posts setObject:self.currentPostField.text forKey:inputTime];
            
            [currUserDict[userID] setObject:posts forKey:@"posts"];
            [[[_ref child:@"users"] child:userID] setValue:currUserDict[userID]];
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1);
        [self alertUser:@"User Post" message:@"Message Submitted!"];
        dispatch_after(delay, dispatch_get_main_queue(), ^(void) {
             [self viewWillAppear:NO];
        });
    }
    
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
                        [data setObject:time forKey:@
                         "time"];
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
        CGRect frame = CGRectMake(0, totalHeight, 250, 150);
        
        UITextView* tview = [[UITextView alloc] initWithFrame:frame];
        NSLog(@"Here 3");
        tview.text = [posts[i] objectForKey:@"message"];
        tview.textColor = [UIColor blackColor];
        tview.backgroundColor = [UIColor colorWithRed:255 green:251 blue:241 alpha:1];
        tview.editable = NO;
        
        [containerView addSubview:tview];
        
        // Increment our maximum width & total height
        maximumWidth = MAX(maximumWidth, tview.contentSize.width);
        totalHeight += tview.contentSize.height;
    }
    // Size the container view to fit. Use its size for the scroll view's content size as well.
    containerView.frame = CGRectMake(0, 0, maximumWidth, totalHeight);
    containerView.center = scrollView.center;
    scrollView.contentSize = containerView.frame.size;
    // Minimum and maximum zoom scales
    scrollView.minimumZoomScale = scrollView.frame.size.width / maximumWidth;
    scrollView.maximumZoomScale = 4.0;
    self.currentPostField.text = @"";
    
    
    
    
//    for (NSString* time in posts) {
        
 //   }
}

- (void)alertUser:(NSString *)title message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:dismissAction];
        [self presentViewController:alert animated: true completion: nil];
    });
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

-(NSString*) getDate {
    NSDate *date = [[NSDate alloc] init];
    NSString* time = [NSString stringWithFormat:@"%@", date];
    NSArray* arr = [time componentsSeparatedByString:@" "];
    NSArray* yymmdd = [arr[0] componentsSeparatedByString:@"-"];
    NSArray* hhmmss =[arr[1] componentsSeparatedByString:@":"];
    NSString* inputTime = [NSString stringWithFormat:@"%@%@%@%@%@%@",hhmmss[0],hhmmss[1],hhmmss[2],yymmdd[1] ,yymmdd[2] ,yymmdd[0]];
    return inputTime;
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
