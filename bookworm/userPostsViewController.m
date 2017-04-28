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
            NSDictionary *postDict = snapshot.value;
            NSString* idKey;
            for (NSString* key in postDict) {
                if ([postDict[key] containsObject:user.email]) {
                    idKey = key;
                }
            }
         //   NSLog(@"Hello 2");
            self.usernameLabel.text = [NSString stringWithFormat:@"%@", [postDict[idKey] objectForKey:@"username"]];
            // ...
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
        /*
        [[[[self.ref child:@"posts"] queryOrderedByChild:@"time"]
          queryEqualToValue:user.email] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
                if (snapshot.value != [NSNull null]){
                    NSDictionary *dict = snapshot.value;
                    //self.objects = [dict allKeys];
                //    self.books = [NSMutableArray arrayWithArray:self.objects];
                //    [self.tableView reloadData];
            }
        }];*/
    }

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
