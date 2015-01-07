//
//  HTTPPost.m
//  SWAGLibrary
//
//  Created by Yose on 1/6/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "HTTPPost.h"
#import "AFHTTPRequestOperationManager.h"


/*
 
The below code is is from a a REST API request originally from
http://afnetworking.com
 with all credit given to creativepulse.gr for the boilerplate convenience 
 of creating the POST request
 
 
 
 */

@implementation HTTPPost



+(BOOL) createNewBook:(NSString*) url :(NSDictionary*) parameters
{
//    used to tell if the book was sucessfully created
    __block BOOL wasSuccessful = false;

//    Create the request manager that will handle the post operation
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    Tell the request manager to send the POST command with the given url and book parameters
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject != nil) {
//            the book creation was succesfully
//            can let user know the book creation was successful
            
            wasSuccessful = true;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            NSLog(@"An error occurred. - %@ ", error.localizedDescription);
            
            wasSuccessful = false;
        }
        
        
    }];

    
    return wasSuccessful;
    
}






@end
