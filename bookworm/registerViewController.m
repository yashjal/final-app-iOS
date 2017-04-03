//
//  registerViewController.m
//  bookworm
//
//  Created by Raify Hidalgo on 4/2/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "registerViewController.h"
#include <CommonCrypto/CommonDigest.h>

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
- (IBAction)register:(id)sender {
    if (self.regUsername.text != Nil && self.regEmail != Nil && self.regPwd != Nil) {
        [[FIRAuth auth] signInWithEmail:self.regEmail.text
                               password:self.regPwd.text
                             completion:^(FIRUser *user, NSError *error) {
                                 NSLog(@"User Registered");
                                 NSString* sha = [self createSHA512:self.regPwd.text];
                                 NSMutableDictionary* data = [[NSMutableDictionary alloc]init];
                                [data setObject:self.regUsername.text forKey:@"username"];
                                [data setObject:self.regEmail.text forKey:@"email"];
                                [data setObject:sha forKey:@"password"];
                                 [data setObject:@"N/A" forKey:@"address"];
                                [data setObject:@"N/A" forKey:@"fav"];
                                [data setObject:@"N/A" forKey:@"first_name"];
                                [data setObject:@"N/A" forKey:@"last_name"];
                                [data setObject:@"N/A" forKey:@"messages"];
                                [data setObject:@"N/A" forKey:@"phone"];
                                 [[[_ref child:@"users"] childByAutoId] setValue:data];
                                 [self performSegueWithIdentifier:@"regToMain" sender:Nil];
                             }];
    }
}

// Attribute: http://stackoverflow.com/questions/25023376/how-can-i-hash-a-nsstring-to-sha512
- (NSString *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    return [out description];
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
