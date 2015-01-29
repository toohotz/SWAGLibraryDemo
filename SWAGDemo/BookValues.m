//
//  BookValues.m
//  SWAGDemo
//
//  Created by Yose on 1/12/15.
//  Copyright (c) 2015 Yose. All rights reserved.
//

#import "BookValues.h"

@implementation BookValues



+(instancetype)sharedManager
{
    static BookValues *sharedMyManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[super allocWithZone:NULL] init];
    });
    return sharedMyManager;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}


@end



@implementation NewBookValues

+(id)sharedManager
{
    static NewBookValues *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[super allocWithZone:NULL] init];
    });
    return sharedMyManager;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedManager];
}


@end