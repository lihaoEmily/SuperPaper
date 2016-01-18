//
//  UserSession.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserSession.h"

#define ROLE_TEACHER @"Teacher"
#define ROLE_STUDENT @"Student"

@interface UserSession()

@end

@implementation UserSession

NSString *const kUserRole  = @"UserRole";
NSString *const kUserName  = @"UserName";
NSString *const kUserID    = @"UserId";
NSString *const kUserTel   = @"UserTel";
NSString *const kUserToken = @"UserToken";

#pragma mark - Create the singleton
+ (UserSession *)sharedInstance {
    static dispatch_once_t onceToken;
    static UserSession *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UserSession alloc] init];
    });
    return sSharedInstance;
}

#pragma mark - UserRole Getter
- (UserRole)currentRole {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    id role = [userDefaults valueForKey:kUserRole];
    
    if ([role isEqual:@(kUserRoleStudent)]) {
        return kUserRoleStudent;
    } else {
        return kUserRoleTeacher;
    }
}

#pragma mark - UserRole Setter
- (void)setCurrentRole:(UserRole)currentRole {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(currentRole) forKey:kUserRole];
    [userDefaults synchronize];
}

#pragma mark - Store the information for the current user
- (void)saveUserProfileWithInfo:(NSDictionary *)infoDic {
    if ([infoDic count] == 0 || infoDic == nil) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [infoDic allKeys];
    for (NSString * key in array) {
        NSString * keyString = nil;
        if (self.currentRole == kUserRoleStudent) {
            keyString = [NSString stringWithFormat:@"%@%@",ROLE_STUDENT,key];
        } else {
            keyString = [NSString stringWithFormat:@"%@%@",ROLE_TEACHER,key];
        }
        if (keyString) {
            [userDefaults setValue:infoDic[key] forKey:keyString];
        }
    }
    [userDefaults synchronize];
}

#pragma mark - Get a information about the current user via a key string
- (id)currentUserProfileForKey:(NSString *)keyString {
    if (keyString == nil) {
        return nil;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    NSString * key = nil;
    id value = nil;
    if (self.currentRole == kUserRoleStudent) {
        keyString = [NSString stringWithFormat:@"%@%@",ROLE_STUDENT,keyString];
    } else {
        keyString = [NSString stringWithFormat:@"%@%@",ROLE_TEACHER,keyString];
    }
    if (key) {
        value = [userDefaults valueForKey:key];
    }
    return value;
}

@end
