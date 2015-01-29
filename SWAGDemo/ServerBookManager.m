//
//  BookRetrieval.m
//  SWAGDemo
//
//  Created by Yose on 1/12/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

/*
 This is the Server Manager Model that will control 
 book retrieval and creation process. This manager will be
 used in classes that require interactions to be made between
 values stored on the Prolific server and new values that will
 be created on the server. The Server Manager Model is the only 
 means of manipulating the singleton that is backed by this model 
 manager.

*/

#import "ServerBookManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "BookValues.h"
#import "CreatedBookValues.h"
@implementation ServerBookManager

/**
 @description Retrieves book information from server for SWAGLibrary
 @important Values are stored into ServerBookManager's singleton properties
 */
+(void)retrieveTableViewBookInformation
{
    
//    temporary arrays that will hold new server values
    
    NSMutableArray *newAuthors = [[NSMutableArray alloc] init];
    NSMutableArray *newBookTitles = [[NSMutableArray alloc] init];
    NSMutableArray *newBookIndicies = [[NSMutableArray alloc] init];
    
     BookValues *bookValuesManager = [[BookValues alloc] init];
    //    Create the request manager that will handle the get operation
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:serverURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
//        if the get request succeeded
        if (responseObject != nil) {
            
//            array of all the books received from the server
            NSArray *books = responseObject;
            
//      use a sort descriptor to sort by ascending ID number (for tableview purposes)
        
            NSSortDescriptor *bookSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:bookSortDescriptor];
            
//            new arrays that will hold sorted values
            NSArray *sortedBookArray = [books sortedArrayUsingDescriptors:sortDescriptors];
            
            /*
             fast enumerate through the books to grab the authors, book titles, and book ID numbers and put them
             into their respective arrays that will propogate the datasource array of the tableview
             
             */
            
            NSLog(@"%@", sortedBookArray);
            for (NSDictionary *book in sortedBookArray) {
                
                NSString *author = [book valueForKey:@"author"];
                [newAuthors addObject:author];
                
                NSString *bookTitles = [book valueForKey:@"title"];
                [newBookTitles addObject:bookTitles];
                
                NSNumber *bookID = [book valueForKey:@"id"];
                [newBookIndicies addObject:bookID];

            }

                bookValuesManager.authors = newAuthors;
                bookValuesManager.titles = newBookTitles;
                bookValuesManager.bookNumbers = newBookIndicies;

            
//            NSNumber arithmetic manipulation to increase index count for next book
            
            NSNumber *number;
            number = [ServerBookManager bookIDs].lastObject;

            int addedNumber = [number intValue] + 1;
            number = [NSNumber numberWithInt:addedNumber];
            [ServerBookManager setNewBookIDWithID:number];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}

+(void)retrieveBookAtIndex:(NSUInteger)bookIndex
{
    NSUInteger bookNumber = bookIndex + 1;
    NSString *bookCharacter = [NSString stringWithFormat:@"%u", bookNumber];
    NSString *bookURL = [NSString stringWithFormat:@"%@%@",serverURL, bookCharacter];
    
    //    Create the request manager that will handle the get operation
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:bookURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil) {
            
//            assign books values that are received from the server to ivars
            
            NSDictionary *bookInformation = responseObject;
            
            NSString *author = [bookInformation valueForKey:@"author"];
            NSString *title = [bookInformation valueForKey:@"title"];
            NSString *categories = [bookInformation valueForKey:@"categories"];
            NSString *publisher = [bookInformation valueForKey:@"publisher"];
            NSString *lastCheckedOut = [bookInformation valueForKey:@"lastCheckedOut"];
            NSString *lastCheckedOutBy = [bookInformation valueForKey:@"lastCheckedOutBy"];
            NSNumber *idNumber = [bookInformation valueForKey:@"id"];
            
//            Check to see if book has been checked out

            if (lastCheckedOut == (id)[NSNull null] || lastCheckedOutBy == (id)[NSNull null]) {
                lastCheckedOut = @"This book has not been checked out yet";
                lastCheckedOutBy = @"";
            }
            
            
            else
            {
                lastCheckedOut = [ServerBookManager formatTimeForUserFrom:lastCheckedOut];
                lastCheckedOut = [NSString stringWithFormat:@"This book has been checked out on %@" " by ", lastCheckedOut];
            }
            
//            assign singleton values for book information here
            
            BookValues *newBookVals = [[BookValues alloc] init];
         
            newBookVals.author = author;
            newBookVals.bookTitle = title;
            newBookVals.bookCategories = categories;
            newBookVals.publisher = publisher;
            newBookVals.lastCheckedOut = lastCheckedOut;
            newBookVals.lastCheckedOutBy = lastCheckedOutBy;
            newBookVals.serverIdNumber = idNumber;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

+(void)createNewBookWithInformation:(NSDictionary*)bookInformation
{

    if (bookInformation != nil) {

        //    Create the request manager that will handle the put operation
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:serverURL parameters:bookInformation success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (responseObject != nil) {
                //      let user know book was successfully created
                
                [[NewBookValues sharedManager] setWasCreated:YES];
            }
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //        let user know book was not successfully created
            [[NewBookValues sharedManager] setWasCreated:NO];
            
        }];
    }
}

+(void)editBookAtIndex:(NSUInteger)bookIndex editedBy:(NSString*)editor
{
    [ServerBookManager setNewLastCheckedOutBy:[ServerBookManager serverTimeFormattingSetting]];

    NSUInteger bookNumber= bookIndex+ 1;
    
    NSString *bookURL = [NSString stringWithFormat:@"%@%u",serverURL, bookNumber];
    
//    Dictionary that will hold updated time of checkout and person whom checked out the book
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:editor forKey:@"lastCheckedOutBy"];
    [parameters setObject:[ServerBookManager serverTimeFormattingSetting] forKey: @"lastCheckedOut"];
    
    //    Create the request manager that will handle the put operation
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager PUT:bookURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject != nil) {
//            notify user that the book has been successfully edited
            [[BookValues sharedManager] setWasEdited:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
//        let user know that the book was not successfully edited
       
        if (error) {
            [[BookValues sharedManager] setWasEdited:NO];
        }
    }];
    
}

+(void)deleteBookAtIndex:(NSUInteger)bookIndex
{
//    initialize the book manager to retrieve values from
    
    BookValues *bookValuesManager = [[BookValues alloc] init];
    
//    find the index of the selected book
    
    
    NSNumber *deleteIndex = [bookValuesManager.bookNumbers objectAtIndex:bookIndex];
    
//    form url source for book to be deleted
    NSString *bookURL = [NSString stringWithFormat:@"%@%@",serverURL, deleteIndex];

    
    /// Manager that will handle the delete operation
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager DELETE:bookURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if (responseObject != nil) {
//            notify user that the book was successfully deleted
            bookValuesManager.isDeleted = TRUE;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error) {
            bookValuesManager.isDeleted = FALSE;
        }
    }];
}

+(void)deleteAllBooks
{
    /// Manager that will handle the delete operation
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager DELETE:serverURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // notify user that all books have been deleted
        [[BookValues sharedManager] setIsDeleted:TRUE];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error) {
            [[BookValues sharedManager] setIsDeleted:FALSE];
        }
        
    }];
}


#pragma mark - Singleton server assigners

+(void)setBookID:(NSNumber*)bookID
{
    
    if (bookID) {
   
        [[NewBookValues sharedManager] setBookNumber:bookID];
    }
    
}

+(void)setBookTitle:(NSString *)aBookTitle
{
    if (aBookTitle != nil) {
        [[BookValues sharedManager] setBookTitle:aBookTitle];
    }
}

+(void)setPublisher:(NSString *)aPublisher
{
    if (aPublisher != nil) {
        [[BookValues sharedManager] setPublisher:aPublisher];
    }
}

+(void)setBookCategories:(NSString *)bookCategories
{
    if (bookCategories != nil) {
        [[BookValues sharedManager] setBookCategories:bookCategories];
    }
}

+(void)setLastCheckedOutBy:(NSString *)lastCheckedOutBy
{
    if (lastCheckedOutBy != nil) {
        [[BookValues sharedManager] setLastCheckedOutBy:lastCheckedOutBy];
    }

}

+(void)setLastCheckedOut:(NSString *)lastCheckedOut
{
    if (lastCheckedOut != nil) {
        [[BookValues sharedManager] setLastCheckedOut:lastCheckedOut];
    }
}

+(NSDictionary*)createBookParameters
{
    return [[BookValues sharedManager] bookParameters];
}



+(void)setCurrentBookIndex:(NSUInteger)bookIndex
{
    if (bookIndex) {
        [[BookValues sharedManager] setCurrentBookIndex:bookIndex];
    }
}

#pragma mark - Singleton getter property methods

+(NSArray*)bookIDs
{
    NSArray *array = [[NSArray alloc] initWithArray:[[BookValues sharedManager] bookNumbers]];
    
    return array;
}

+(NSMutableArray*)bookTitles
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[BookValues sharedManager] titles]];
    
    return array;
}

+(NSMutableArray*)bookAuthors
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[BookValues sharedManager] authors]];
   
    return array;
}

+(NSString*)author
{
    return [[BookValues sharedManager] author];
}

+(NSString*)title
{
    return [[BookValues sharedManager] bookTitle];
}

+(NSString*)publisher
{
    return [[BookValues sharedManager] publisher];
}

+(NSString*)categories
{
    return [[BookValues sharedManager] bookCategories];
}

+(NSString*)lastCheckedOutBy
{

    return [[BookValues sharedManager] lastCheckedOutBy];
}

+(NSString*)lastCheckedOut
{
   
    return [[BookValues sharedManager] lastCheckedOut];
}

+(NSNumber*)serverIdNumber
{
    return [[BookValues sharedManager] serverIdNumber];
}

+(NSUInteger)currentBookIndex
{
    return [[BookValues sharedManager] currentBookIndex];
}

+(NSNumber*)nextBookNumber
{
   return [[NewBookValues sharedManager] newidNumber];
}

#pragma mark - Singleton new book assigners

+(void)setNewBookIDWithID:(NSNumber*)bookID
{
    if (bookID != nil) {
        [[NewBookValues sharedManager] setNewidNumber:bookID];
    }
}

+(void)setNewBookTitleWithTitle:(NSString *)bookTitle
{
    
        CreatedBookValues *bookValues = [[CreatedBookValues alloc] init];
        bookValues.bookTitle = bookTitle;
    
}

+(void)setNewBookAuthorWithName:(NSString *)bookAuthor
{
    
        CreatedBookValues *bookValues = [[CreatedBookValues alloc] init];
        bookValues.author = bookAuthor;
    
}

+(void)setNewBookPublisherWithName:(NSString *)bookPublisher
{
    if (bookPublisher != nil) {
        [[NewBookValues sharedManager] setPublisher:bookPublisher];
    }
}

+(void)setNewBookCategoryWithName:(NSString *)newCategory
{
    if (newCategory != nil) {
        [[NewBookValues sharedManager] setCategories:newCategory];
    }
}

+(void)setNewLastCheckedOutBy:(NSString *)lastCheckedOutBy
{
    if (lastCheckedOutBy != nil) {
        [[NewBookValues sharedManager] setLastCheckedOutBy:lastCheckedOutBy];
    }
}

+(void)setNewLastCheckedOut:(NSString *)lastCheckedOut
{
    if (lastCheckedOut != nil) {
        [[NewBookValues sharedManager] setLastCheckedOut:lastCheckedOut];
    }
}


#pragma mark - Server time formatting
/**
 @description Formats the current time into the proper format for the Prolific server
 @returns The properly formatted time as a string
 */
+(NSString *)serverTimeFormattingSetting
{
    NSString *outputDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";
    
    outputDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return outputDate;
}

#pragma mark - Time Converter method
/**
 @description Formats the given server time into a more readable format
 @param serverTime The server time passed in
 @returns A properly formatted time for the user
 */
+(NSString*)formatTimeForUserFrom:(NSString*)serverTime
{
    NSString *formattedTime = [[NSString alloc] init];
    
    if (serverTime) {

        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
        dateFormatter.locale = [NSLocale currentLocale];
        dateFormatter.formatterBehavior = NSDateFormatterBehaviorDefault;

        
        NSDate *dateFromString = [dateFormatter dateFromString:serverTime];
        
        NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];
        newFormatter.dateStyle = NSDateIntervalFormatterFullStyle;
        
        
        formattedTime = [newFormatter stringFromDate:dateFromString];
    }
    
    return formattedTime;
}


@end
