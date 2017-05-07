//
//  MyBooksTableViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/16/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "MyBooksTableViewController.h"
#import "MyBooksDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@import Firebase;


@interface MyBooksTableViewController ()

@property NSArray *objects;
@property NSMutableArray *books;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end

@implementation MyBooksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.ref = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    FIRUser *user = [FIRAuth auth].currentUser;
    
    if (user) {
        //read all the books owned by this current logged in user
        [[[[self.ref child:@"books"] queryOrderedByChild:@"user"]
          queryEqualToValue:user.email] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            if (snapshot.value != [NSNull null]){
                NSDictionary *dict = snapshot.value;
                self.objects = [dict allKeys];
                self.books = [NSMutableArray arrayWithArray:self.objects];
                [self.tableView reloadData];
                
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = self.books[indexPath.row];
        NSString *object1 = [NSString stringWithFormat:@"%@.jpg",object];
        
        //set the details of the book of the selected row
        [[[self.ref child:@"books"] child:object] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *dict = snapshot.value;
            MyBooksDetailViewController *controller = (MyBooksDetailViewController *)[segue destinationViewController];
            [controller setBook:object author:[dict objectForKey:@"author"] publisher:[dict objectForKey:@"publ"] condition:[dict objectForKey:@"condition"] summary:[dict objectForKey:@"summary"] user:[dict objectForKey:@"user"]];
        }];
        
        //set the image of the book of the selected row
        [[self.storageRef child:object1] dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            MyBooksDetailViewController *controller = (MyBooksDetailViewController *)[segue destinationViewController];
            if (error != nil) {
                [controller setImage:[UIImage imageNamed:@"default-book-cover.jpg"]];
            } else {
                [controller setImage:[UIImage imageWithData:data]];
            }
        }];
        
        //sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"page-flip-01a" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
    }
}


#pragma mark - Table View

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
    cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:18.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *object = self.books[indexPath.row];
        NSString *object1 = [NSString stringWithFormat:@"%@.jpg",object];
        
        //delete selected book from database
        [[[self.ref child:@"books"] child:object] setValue:nil withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            [self.books removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        //delete corresponding image from storage
        [[self.storageRef child:object1] deleteWithCompletion:^(NSError *error){
            if (error != nil) {
                NSLog(@"No image");
            } else {
                NSLog(@"Image deleted successfully");
            }
        }];
        
        //sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"paper-rip-3" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
