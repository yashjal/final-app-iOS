//
//  AddBookViewController.m
//  bookworm
//
//  Created by Yash Jalan on 4/23/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "AddBookViewController.h"
#import "AddMapViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@import Firebase;


@interface AddBookViewController () <AddMapViewControllerDelegate>

@property(strong, nonatomic) FIRAuthStateDidChangeListenerHandle handle;

@end

@implementation AddBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ref = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    
    //touching outside textfield removes keyboard
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //adjust frame of view controller when user hits a text field
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow)
        name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide)
        name:UIKeyboardWillHideNotification object:nil];
    
    //check if camera available on device
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addBook:(id)sender {
    //add book
    if (self.Title.text != Nil && self.Author.text != Nil && self.Condition.text != Nil && self.Summary.text != Nil && self.Publisher.text != Nil && [FIRAuth auth].currentUser) {
        
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
                
                //add image
                if (self.imageView.image) {
                    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.25);
                    NSString *imagePath = [NSString stringWithFormat:@"%@.jpg",self.Title.text];
                    
                    FIRStorageMetadata *metadata = [FIRStorageMetadata new];
                    metadata.contentType = @"image/jpeg";
                
                    [[self.storageRef child:imagePath] putData:imageData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                        if (error) {
                            NSLog(@"Error uploading: %@", error);
                        }
                        else {
                            NSLog(@"Upload Succeeded!");
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
                
                else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            
        }];
        
        //sound
        NSString *path = [ [NSBundle mainBundle] pathForResource:@"shuffling-cards-4" ofType:@"wav"];
        SystemSoundID theSound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
        AudioServicesPlaySystemSound (theSound);
        
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
        //UIStoryboardSegue* segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"signout" source:self.view destination:emailSignInViewController];
        NSLog(@"Google Signed Out");
    } else {
        NSLog(@"Logged Out");
    }
    
    //sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"paper-rip-3" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);
    
}

- (void)mapViewController:(AddMapViewController *)addMap lattitude:(NSString *)latt longitude: (NSString *)longt {
    //since this is a delegate of addMapViewController, we get the map's location
    [addMap dismissViewControllerAnimated:YES completion:nil];
    self.lattitude.text = latt;
    self.longitude.text = longt;
    
}

- (IBAction)backPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        AddMapViewController *addMap = segue.destinationViewController;
        addMap.delegate = self;
    }
}

// keyboard help from: http://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present

#define kOFFSET_FOR_KEYBOARD 40.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }

}

-(void)keyboardWillHide {
    //return to normal frame
    if (self.view.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }

}

-(void)setViewMovedUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    self.imageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
