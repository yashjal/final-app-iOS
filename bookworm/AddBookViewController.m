//
//  AddBookViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/23/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "AddBookViewController.h"
#import "AddMapViewController.h"
@import Firebase;


@interface AddBookViewController () <AddMapViewControllerDelegate>

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
    if (self.Title.text != Nil && self.Author.text != Nil && self.Condition.text != Nil && self.Summary.text != Nil && self.Publisher.text != Nil && [FIRAuth auth].currentUser) {
        
        //NSMutableDictionary* dt = [[NSMutableDictionary alloc]init];
        FIRUser *user = [FIRAuth auth].currentUser;
        
        NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
    
        [data setObject:self.Author.text forKey:@"author"];
        
        [data setObject:self.Condition.text forKey:@"condition"];
        [data setObject:self.Summary.text forKey:@"summary"];
        [data setObject:self.Publisher.text forKey:@"publ"];
        [data setObject:user.email forKey:@"user"];
        if (self.lattitude.hasText && self.longitude.hasText) {
            [data setObject:self.lattitude.text forKey:@"lattitude"];
            [data setObject:self.longitude.text forKey:@"longitude"];
        }
    
        [[[_ref child:@"books"] child:self.Title.text] setValue:data withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
                //NSLog(@"HERE");
            }

            
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
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSError* configureError;
    if ([GIDSignIn sharedInstance].currentUser) {
        [[GIDSignIn sharedInstance] signOut];
        //SignInViewController* signvc;
    //    UIStoryboardSegue* segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"signout" source:self.view destination:emailSignInViewController];
        NSLog(@"Google Signed Out");
    } else {
        NSLog(@"Logged Out");
    }
    
}

- (void)mapViewController:(AddMapViewController *)addMap lattitude:(NSString *)latt longitude: (NSString *)longt {
    [addMap dismissViewControllerAnimated:YES completion:nil];
    self.lattitude.text = latt;
    self.longitude.text = longt;
    
    //NSLog(@"Here");
   // NSLog(@"long: %@",longt);
}
- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        AddMapViewController *addMap = segue.destinationViewController;
        addMap.delegate = self;
    }
}


@end
