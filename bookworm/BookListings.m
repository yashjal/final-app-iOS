//
//  BookListings.m
//  bookworm
//
//  Created by Yash Jalan on 4/15/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "BookListings.h"
#import "MyBooksDetailViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@import Firebase;

@interface BookListings ()

@property (copy, nonatomic) NSArray *books;
@property (nonatomic, strong) NSMutableDictionary *dictBooks;
@property (copy, nonatomic) NSArray *bookSectionTitles;


@end

//sounds from: https://www.soundjay.com/

@implementation BookListings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];
    self.storageRef = [[FIRStorage storage] reference];
    
    //edit table view
    UITableView *tableView = (id)[self.view viewWithTag:1];
    UIEdgeInsets contentInset = tableView.contentInset;
    contentInset.top = 20;
    [tableView setContentInset: contentInset];
    
    //sound
    NSString *path = [ [NSBundle mainBundle] pathForResource:@"shuffling-cards-4" ofType:@"wav"];
    SystemSoundID theSound;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSound);
    AudioServicesPlaySystemSound (theSound);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    //read all "books" in database
    [[self.ref child:@"books"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
        
        //all book names
        self.books = [dict allKeys];
        
        //key=alphabet, value=book name
        self.dictBooks = [self sectionSetup:self.books];
        self.bookSectionTitles = [[self.dictBooks allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        [tableView reloadData];
    }];
}

/*
Takes all the book titles and creates a dictionary with
key=alphabet; value=book title starting with that alphabet
*/
-(NSMutableDictionary *)sectionSetup:(NSArray *)bookTitles {
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    
    for (NSString *word in bookTitles) {
        
        NSString *firstLetter = [[word substringToIndex:1] uppercaseString];
        NSMutableArray *letterList = [d objectForKey:firstLetter];
        if (!letterList) {
            letterList = [NSMutableArray array];
            [d setObject:letterList forKey:firstLetter];
        }
        //if (![letterList containsObject:word]) {
        [letterList addObject:word];
        //}
    }
    
    return d;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetail2"]) {
        UITableView *tableView = (id)[self.view viewWithTag:1];
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSString *sectionTitle = [self.bookSectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionBooks = [self.dictBooks objectForKey:sectionTitle];
        NSString *book = [sectionBooks objectAtIndex:indexPath.row];
        NSString *book1 = [NSString stringWithFormat:@"%@.jpg",book];
        
        //set the details of the book of the selected row
        [[[self.ref child:@"books"] child:book] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //NSLog(@"snapshot = %@",snapshot.value);
            NSDictionary *dict = snapshot.value;
            MyBooksDetailViewController *controller = (MyBooksDetailViewController *)[segue destinationViewController];
            [controller setBook:book author:[dict objectForKey:@"author"] publisher:[dict objectForKey:@"publ"] condition:[dict objectForKey:@"condition"] summary:[dict objectForKey:@"summary"] user:[dict objectForKey:@"user"]];
            
        }];
        
        //set the image of the book of the selected row
        [[self.storageRef child:book1] dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
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


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.bookSectionTitles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.bookSectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.bookSectionTitles objectAtIndex:section];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self.bookSectionTitles objectAtIndex:section];
    NSArray *sectionBooks = [self.dictBooks objectForKey:sectionTitle];
    return [sectionBooks count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        
    }
    // I now have a cell - either recycle or created afresh
    
    NSString *sectionTitle = [self.bookSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionBooks = [self.dictBooks objectForKey:sectionTitle];
    NSString *book = [sectionBooks objectAtIndex:indexPath.row];
    cell.textLabel.text = book;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:18.0];
    cell.textLabel.textAlignment  = NSTextAlignmentCenter;
    
    //cell.imageView.image = [UIImage imageNamed:[self getImageFilename:animal]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 40;
}

@end
