//
//  BookListings.m
//  bookworm
//
//  Created by Yash Jalan on 4/15/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "BookListings.h"
#import "MyBooksDetailViewController.h"
@import Firebase;

@interface BookListings ()

@property (copy, nonatomic) NSArray *books;
@property (nonatomic, strong) NSMutableDictionary *dictBooks;
@property (copy, nonatomic) NSArray *bookSectionTitles;


@end

@implementation BookListings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];    
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    UIEdgeInsets contentInset = tableView.contentInset;
    
    contentInset.top = 20;
    
    [tableView setContentInset: contentInset];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITableView *tableView = (id)[self.view viewWithTag:1];
    
    [[self.ref child:@"books"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //NSLog(@"snapshot = %@",snapshot.value);
        NSDictionary *dict = snapshot.value;
        self.books = [dict allKeys];
        //NSArray *x = [dict allKeys];
        self.dictBooks = [self sectionSetup:self.books];
        
        self.bookSectionTitles = [[self.dictBooks allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        
        [tableView reloadData];
    }];
}

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
        
        [[[self.ref child:@"books"] child:book] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //NSLog(@"snapshot = %@",snapshot.value);
            NSDictionary *dict = snapshot.value;
            MyBooksDetailViewController *controller = (MyBooksDetailViewController *)[segue destinationViewController];
            [controller setBook:book author:[dict objectForKey:@"author"] publisher:[dict objectForKey:@"publ"] condition:[dict objectForKey:@"condition"] summary:[dict objectForKey:@"summary"] user:[dict objectForKey:@"user"]];

            
        }];
        
        
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
    cell.textLabel.textColor = [UIColor colorWithRed:100 green:150 blue:100 alpha:1];
    cell.textLabel.textAlignment  = NSTextAlignmentCenter;

    
    //cell.imageView.image = [UIImage imageNamed:[self getImageFilename:animal]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 80;
}

@end
