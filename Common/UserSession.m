//
//  UserSession.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserSession.h"

@interface UserSession()

@end

@implementation UserSession

#pragma mark - Create the singleton
+ (UserSession *)sharedInstance {
    static dispatch_once_t onceToken;
    static UserSession *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UserSession alloc] init];
    });
    return sSharedInstance;
}

@end
