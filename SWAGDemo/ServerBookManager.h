//
//  BookRetrieval.h
//  SWAGDemo
//
//  Created by Yose on 1/12/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import <Foundation/Foundation.h>

#define serverURL @"http://prolific-interview.herokuapp.com/54945649b3bb43000798b8df/books/"



@class BookValues;
@class NewBookValues;

@interface ServerBookManager : NSObject


/**
 @description Retrieves author and book title information for tableview
 */
+(void)retrieveTableViewBookInformation;
/**
 @description Retrieves a book at the given index number from the server.
 @param bookIndex Index of the book on server
 */
+(void)retrieveBookAtIndex:(NSUInteger)bookIndex;
+(void)createNewBookWithInformation:(NSDictionary*)bookInformation;
/**
 Checkout a particular book at a given index
 @param bookIndex Index of the book on server
 @param editor Person who committed the edit to book
 */
+(void)editBookAtIndex:(NSUInteger)bookIndex editedBy:(NSString*)editor;
/**
 @description Deletes a book at a specified index on server
 @param bookIndex Index of book on server
 */
+(void)deleteBookAtIndex:(NSUInteger)bookIndex;
/**
 @description Deletes all books from the Prolific SWAG server
 */
+(void)deleteAllBooks;

#pragma mark - Singleton setter property methods
/**
 Assigns the singleton boookID property to the given ID
 @param aBookID The ID of the given book to assign
 */
+(void)setBookID:(NSNumber*)aBookID;
/**
 Assigns the singleton book title property to the given title
 @param aBookTitle The book title of the given book to assign
 */
+(void)setBookTitle:(NSString*)aBookTitle;
/**
 Assigns the singleton book publisher property to the given publisher
 @param aPublisher The book publisher of the given book to assign
 */
+(void)setPublisher:(NSString*)aPublisher;
/**
 Assigns the singleton book category or categories property to the given category string
 @param bookCategories The book category of the given book to assign
 */
+(void)setBookCategories:(NSString*)bookCategories;
/**
 Assigns the singleton lastCheckedOutBy property to the given name
 @param lastCheckedOutBy The book's last checked out user of the given book to assign
 */
+(void)setLastCheckedOutBy:(NSString*)lastCheckedOutBy;
/**
 Assigns the singleton lastCheckedOut property to the given date
 @param lastCheckedOut The book's last checked out date to assign
 */
+(void)setLastCheckedOut:(NSString*)lastCheckedOut;

/**
 @description Sets the current book index for selected book
 @param bookIndex Index of book selected
 */
+(void)setCurrentBookIndex:(NSUInteger)bookIndex;

#pragma mark - Singleton getter property methods


/**
 @description Array which holds all current book ID numbers
 @returns Array of book IDs from Prolific SWAG server
 */
+(NSArray*)bookIDs;
/**
 @description Mutable array which holds the current book titles
 @returns Array of book titles
 */
+(NSMutableArray*)bookTitles;
/**
 @description Mutable array which holds the current book authors
 @returns Array of book authors
 */
+(NSMutableArray*)bookAuthors;
+(NSString*)author;
+(NSString*)title;
+(NSString*)publisher;
+(NSString*)categories;
+(NSString*)lastCheckedOutBy;
+(NSString*)lastCheckedOut;
/**
 Getter for book parameters of created book
 @returns The current information to create a new book
 */
+(NSDictionary*)createBookParameters;
/**
 @description Book id number from server
 @returns The given book number retrieved from server
 */
+(NSNumber*)serverIdNumber;
/**
 @description Returns the current index of the selected book from tableview
 @returns The current book index of selected book
 */
+(NSUInteger)currentBookIndex;
/**
 Returns the next id for a newly created book in the Prolific server
 @returns The next avaialble book number
 */
+(NSNumber*)nextBookNumber;

#pragma mark - Singleton new book setter methods

/**
 @description Sets the new book ID with the provided ID number
 @param bookID The book ID given to the book to be created
 */
+(void)setNewBookIDWithID:(NSNumber*)bookID;
/**
 @description Sets the new book title with the provided provided author
 @param bookID The book ID given to the book to be created
 */
+(void)setNewBookTitleWithTitle:(NSString *)bookTitle;
+(void)setNewBookAuthorWithName:(NSString *)bookAuthor;
+(void)setNewBookPublisherWithName:(NSString *)bookPublisher;
+(void)setNewBookCategoryWithName:(NSString *)newCategory;
+(void)setNewLastCheckedOutBy:(NSString *)lastCheckedOutBy;
+(void)setNewLastCheckedOut:(NSString *)lastCheckedOut;

@end