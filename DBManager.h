//
//  DBManager.h
//  final-app
//
//  Created by Raify Hidalgo on 3/25/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject // Create database manager that will interact with sqlite database

-(id) initWithFile:(NSString *) file; //

@property (strong, nonatomic) NSString* directoryName;
@property (strong, nonatomic) NSString* sqlFileName;
@property (strong, nonatomic) NSMutableArray* dbFields; // the columns in the database
@property (nonatomic) int rowsReturned; // the rows in the dataabse
@property (nonatomic) long long lastDBIndex;

-(void) duplicateDatabaseIntoDirectory;
-(void) executeQuery:(NSString*) query;
-(NSArray*) loadData:(NSString *) query;
@end
