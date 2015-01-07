//
//  HTTPPost.h
//  SWAGLibrary
//
//  Created by Yose on 1/6/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPPost : NSURL

/**

@paragraph Creates a new book on the server
@params NSString The URL of the book location
@params NSDictionary A dictionary of the values for a book
 
 
 */


+(BOOL) createNewBook:(NSString*) url :(NSDictionary*) parameters;



@end
