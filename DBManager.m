//
//  DBManager.m
//  final-app
//
//  Created by Raify Hidalgo on 3/25/17.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

#import "DBManager.h"
@interface DBManager()
-(void)runQuery:(const char*)query isQueryExecutable:(BOOL)isExecutable;
@property (strong, nonatomic) NSMutableArray *dbDataReturned;
@end

@implementation DBManager
-(id) initWithFile:(NSString *) file {
    self = [super init];
    if (self) {
        NSArray* pathFiles = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); // get the document directory path
        self.sqlFileName = file;
        [self duplicateDatabaseIntoDirectory];
    }
    return self;
}

-(void) duplicateDatabaseIntoDirectory {
    // Check for file existence, duplicate if not already existing - make a copy needed in order to avoid mutating a file directly within app bundle
    
    NSString *destinationFile = [self.directoryName stringByAppendingPathComponent:self.sqlFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationFile]) { // Check to see if database file exists
        
        // if it doesn't exist then create the copy using NSBundle/App Package
        NSString *src = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.sqlFileName];
        NSError* err;
        [[NSFileManager defaultManager] copyItemAtPath:src toPath:destinationFile error:&err];
        
        // Check for error
        if (err != Nil) {
            // Log out error
            NSLog(@"%@",[err localizedDescription]);
        }
        
    }
}

-(void) runQuery:(const char*)query isQueryExecutable:(BOOL)isExecutable {
    sqlite3 *sqlDB; // created locally to only access database when needed, avoid memory leaks/conflicts
    NSString *dbPath = [self.directoryName stringByAppendingPathComponent:self.sqlFileName];
    
    if (self.dbDataReturned != Nil) { // want to initialize the array and clear out all previous elements
        [self.dbDataReturned removeAllObjects];
        self.dbDataReturned = Nil;
    }
    self.dbDataReturned = [[NSMutableArray alloc]init];
    
    if (self.dbFields != Nil) { // remove all elements from database fields, all queries should be run freshly
        [self.dbFields removeAllObjects];
        self.dbFields = Nil;
    }
    self.dbFields = [[NSMutableArray alloc]init];
    
    // After arrays are cleared and memory cleaned, go on to processing query
    BOOL dbIsOpened = sqlite3_open([dbPath UTF8String], &sqlDB);
    if (dbIsOpened == SQLITE_OK) {
        sqlite3_stmt *queryStatement;
        BOOL isStatementOK = sqlite3_prepare_v2(sqlDB, query, -1, &queryStatement, NULL);
        if (isStatementOK == SQLITE_OK) { // database is opened and statement works
            if (isExecutable) { // check if query can be executed
                BOOL isQueryExecuted = sqlite3_step(queryStatement);
                if (isQueryExecuted == SQLITE_DONE) {
                    self.rowsReturned = sqlite3_changes(sqlDB);
                    self.lastDBIndex = sqlite3_last_insert_rowid(sqlDB);
                }
                else { // Error - query did not execute properly
                    NSLog(@"%s", sqlite3_errmsg(sqlDB));
                }
            }
            else { // query not executable - load data from the database
                NSMutableArray *records;
                // Return data row by row
                while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                    records = [[NSMutableArray alloc]init];
                    int totalCols = sqlite3_column_count(queryStatement);
                    
                    // go through columns and return data
                    for (int i = 0; i < totalCols; i++) {
                        char *dbData = (char *) sqlite3_column_text(queryStatement, i); // note - sql uses C characters, not NSString
                        if (dbData != NULL) { // check if field is non-empty
                            [records addObject:[NSString stringWithUTF8String:dbData]];
                        }
                        if (self.dbFields.count != totalCols) {
                            dbData = (char*) sqlite3_column_name(queryStatement, i);
                            [self.dbFields addObject:[NSString stringWithUTF8String:dbData]];
                        }
                        
                    }
                    if (records.count > totalCols) {
                        [self.dbDataReturned addObject:records];
                    }
                }
            }
            sqlite3_finalize(sqlDB);
        }
        else { // statement doesn't work
          NSLog(@"%s", sqlite3_errmsg(sqlDB));
        }
        
        
        
    }
    else { // database was not opened
        NSLog(@"%s", sqlite3_errmsg(sqlDB));
    }
    sqlite3_close(sqlDB);
    
}

-(NSArray*) loadData:(NSString *) query { // return array that contains query data
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    return (NSArray*)self.dbDataReturned;
}

-(void) executeQuery:(NSString *)query {
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}
@end
