//
//  BookListings.m
//  bookworm
//
//  Created by Yash Jalan on 4/15/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "BookListings.h"
@import Firebase;

@interface BookListings ()

@property (copy, nonatomic) NSArray *books;


@end

@implementation BookListings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];
    
    //self.books = @[@"here",@"there"];
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    [[self.ref child:@"books"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"snapshot = %@",snapshot.value);
        NSDictionary *dict = snapshot.value;
        self.books = [dict allKeys];
        [tableView reloadData];
    }];
    
    UIEdgeInsets contentInset = tableView.contentInset;
    
    contentInset.top = 20;
    
    [tableView setContentInset: contentInset];

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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.books count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        
    }
    // I now have a cell - either recycle or created afresh

    
    cell.textLabel.text = self.books [indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;
}

@end
