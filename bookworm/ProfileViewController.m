//
//  ProfileViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/25/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "ProfileViewController.h"
@import Firebase;

@interface ProfileViewController () <MFMailComposeViewControllerDelegate>

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
    
    
    if (self.userEmail && ![self.userEmail isEqualToString:@""] && ![self.userEmail isEqualToString:@"N/A"]) {
        
        [[[[self.ref child:@"users"] queryOrderedByChild:@"email"]
          queryEqualToValue:self.userEmail] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (snapshot.value != [NSNull null]){
                //NSLog(@"snapshot = %@",snapshot.value);
                NSDictionary *dict = snapshot.value;
                NSArray *a = [dict allKeys];
                if (a && [a count] != 0) {
                    self.userTitle.text = [[dict objectForKey:a[0]] objectForKey:@"username"];
                }
                //NSLog(@"%@",[dict objectForKey:a[0]]);
            }
        }];
        
        
        UITableView *tableView = (id)[self.view viewWithTag:1];
        
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
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        
    }
    
    NSString *s = self.books[indexPath.row];
    cell.textLabel.text = s;
    cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:18.0];
    //cell.backgroundColor = [UIColor colorWithRed:255 green:251 blue:240 alpha:1];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contactUser:(id)sender {

    NSString *emailTitle = @"Bookworm: User Interest";
    NSString *messageBody = @"Hey, I'm really interested in your book...";
    NSArray *toRecipents = [NSArray arrayWithObject:self.userEmail];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
     if([MFMailComposeViewController canSendMail]) {
         [self presentViewController:mc animated:YES completion:NULL];
     }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
