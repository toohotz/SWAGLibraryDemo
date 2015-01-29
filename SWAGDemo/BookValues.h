//
//  BookValues.h
//  SWAGDemo
//
//  Created by Yose on 1/12/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

/*
 Singleton used to retrieve book values
 from the Prolific server
 */



#import <Foundation/Foundation.h>

@interface BookValues : NSObject

// Singleton book properties to be used
@property (nonatomic) NSString *author;

@property (nonatomic) NSString *bookTitle;

@property (nonatomic) NSString *publisher;

@property (nonatomic) NSString *bookCategories;

@property (nonatomic) NSString *lastCheckedOutBy;

@property (nonatomic) NSString *lastCheckedOut;

@property (nonatomic) NSNumber *serverIdNumber;

@property (nonatomic) NSUInteger currentBookIndex;

@property (nonatomic) BOOL wasEdited;

@property (nonatomic) BOOL isDeleted;

@property (strong, nonatomic) NSMutableArray *authors;

@property (nonatomic) NSArray *titles;

@property (nonatomic) NSArray *bookNumbers;

@property (strong, readwrite) NSString *myAuthor;

@property (copy) NSDictionary *bookParameters;
+(id)sharedManager;

@end


@interface NewBookValues : NSObject

// Singleton book properties to be used
@property (nonatomic) NSString *author;

@property (nonatomic) NSString *bookTitle;

@property (nonatomic) NSString *publisher;

@property (nonatomic) NSString *categories;

@property (nonatomic) NSString *lastCheckedOutBy;

@property (nonatomic) NSString *lastCheckedOut;

@property (nonatomic) NSNumber *newidNumber;

@property (nonatomic) BOOL wasCreated;

@property (nonatomic) NSNumber *bookNumber;

+(id)sharedManager;

@end