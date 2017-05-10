//
//  registerViewController.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Add description of error if registration is not good

- (IBAction)register:(id)sender { // Make sure all registration fields are filled
    if (self.regUsername.text != Nil && self.regEmail != Nil && self.regPwd != Nil) {
        [[FIRAuth auth] createUserWithEmail:self.regEmail.text
                               password:self.regPwd.text
                             completion:^(FIRUser *user, NSError *error) {
                                 if (error) {
                                     NSLog(@"%@", error.localizedDescription);
                                 } else {
                                     
                                 NSLog(@"User Registered");

                                 NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
                                [data setObject:self.regUsername.text forKey:@"username"];
                                [data setObject:self.regEmail.text forKey:@"email"];
                                 [[[_ref child:@"users"] childByAutoId] setValue:data];
                                 [self animateView:@"regToMain"];
                                 }
                             }];
    }
}

// Add animation to open to next view controller like opening a book
-(void) animateView:(NSString*) segueIdentifier{
    self.view.layer.anchorPoint = CGPointMake(0, 0.5);
    self.view.center  = CGPointMake(self.view.center.x - self.view.bounds.size.width / 2.0f, self.view.center.y);
    [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        CATransform3D d3 = CATransform3DIdentity;
        d3 = CATransform3DMakeRotation(3.141f/2.0f, 0.0f, -1.0f, 0.0f);
        d3.m34 = 0.001f;
        d3.m14 = -0.0015f;
        self.view.layer.transform = d3;
    } completion:^(BOOL finished) {
        if (finished) {
            [self performSegueWithIdentifier:segueIdentifier sender:Nil];
            
        }
    }
     ];
   
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
