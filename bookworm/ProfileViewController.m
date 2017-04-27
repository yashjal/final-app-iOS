//
//  ProfileViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/25/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "ProfileViewController.h"
@import Firebase;

@interface ProfileViewController ()

@property NSArray *objects;
@property NSMutableArray *books;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    if (self.userEmail && ![self.userEmail isEqualToString:@""] && ![self.userEmail isEqualToString:@"N/A"]) {
        [[[[self.ref child:@"books"] queryOrderedByChild:@"user"]
          queryEqualToValue:self.userEmail] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            if (snapshot.value != [NSNull null]){
                //NSLog(@"snapshot = %@",snapshot.value);
                NSDictionary *dict = snapshot.value;
                self.objects = [dict allKeys];
                self.books = [NSMutableArray arrayWithArray:self.objects];
                [tableView reloadData];
                
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *s = self.books[indexPath.row];
    cell.textLabel.text = s;
    return cell;
}
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
