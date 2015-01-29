//
//  CreatedBookValues.m
//  SWAGDemo
//
//  Created by Yose on 1/20/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "CreatedBookValues.h"

@interface CreatedBookValues ()
@property (nonatomic)  NSString *myAuthor;

@end

@implementation CreatedBookValues


-(NSString*)myAuthor
{
    return _myAuthor;
}

-(NSString*)bookTitle
{
    return _bookTitle;
}

- (id)init {
    self = [super init];
    if (self) {
        // initialize
    }
    return self;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [[super allocWithZone:NULL] init];
}
@end
