//
//  CreatedBookValues.h
//  SWAGDemo
//
//  Created by Yose on 1/20/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

/*
 Singleton used to store new book values
 to be submited to the Prolific server
*/

#import <Foundation/Foundation.h>

@interface CreatedBookValues : NSObject

@property (nonatomic) NSString *author;

@property (nonatomic) NSString *bookTitle;

@property (nonatomic) NSString *publisher;

@property (nonatomic) NSString *categories;

@property (nonatomic) NSString *lastCheckedOutBy;

@property (nonatomic) NSString *lastCheckedOut;

@property (nonatomic) NSUInteger idNumber;

@property (nonatomic) BOOL wasCreated;

-(id)init;

@end
