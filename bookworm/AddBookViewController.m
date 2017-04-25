//
//  AddBookViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/23/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "AddBookViewController.h"
@import Firebase;


@interface AddBookViewController ()
@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;
@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.ref = [[FIRDatabase database] reference];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addBook:(id)sender {
    if (self.Title.text != Nil && self.Author.text != Nil && [FIRAuth auth].currentUser) {
        
        //NSMutableDictionary* dt = [[NSMutableDictionary alloc]init];
        FIRUser *user = [FIRAuth auth].currentUser;
        NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
        [data setObject:self.Author.text forKey:@"author"];
        [data setObject:self.Condition.text forKey:@"condition"];
        [data setObject:self.Summary.text forKey:@"summary"];
        [data setObject:self.Publisher.text forKey:@"publ"];
        [data setObject:user.email forKey:@"user"];
    
        [[[_ref child:@"books"] child:self.Title.text] setValue:data withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            [self dismissViewControllerAnimated:YES completion:nil];
            //NSLog(@"HERE");
            
        }];
        
        
    }

    
    
}
- (IBAction)signOut:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    NSLog(@"Logged Out");
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
