//
//  UserSession.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserSession.h"
#import "NavigationController.h"
#import "MainViewController.h"
#import "JPUSHService.h"

#define ROLE_TEACHER @""
#define ROLE_STUDENT @""

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

-(instancetype)init
{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSInteger userID = [userDefaults integerForKey:kUserID];
        if (0 != userID) {
            self.currentUserID = userID;
        }
        
    }
    return self;
}
//#pragma mark - Getter
- (UserRole)currentRole {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *role = [userDefaults valueForKey:kUserRole];
    return role.integerValue;
}

- (NSInteger)currentUserAge
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *age = [userDefaults valueForKey:kUserAge];
    return age.integerValue;
}
-(NSString *)currentUserCollege
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *college = [userDefaults valueForKey:kUserCollege];
    return college;
}
-(UserGen)currentUserGen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *gender = [userDefaults valueForKey:kUserGen];
    return gender.integerValue;
}
-(NSString *)currentUserHeadImageName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *headImageName = [userDefaults valueForKey:kUserHeadImage];
    return headImageName;
}

-(NSInteger)currentUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *userID = [userDefaults valueForKey:kUserID];
    return userID.integerValue;
}
-(NSString *)currentUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefaults valueForKey:kUserName];
    return name;
}
-(NSString *)currentUserNickname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nickname = [userDefaults valueForKey:kUserNickname];
    return nickname;
}
-(NSString *)currentUserTelNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *telNum = [userDefaults valueForKey:kUserTel];
    return telNum;
}
-(NSString *)lastUserTelNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUserTelNum = [userDefaults valueForKey:kUserLastUserTel];
    return lastUserTelNum;
}
-(NSString *)currentUserInviteCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *inviteCode = [userDefaults valueForKey:kUserInviteCode];
    return inviteCode;
}
-(NSString *)currentUserJPushAlias
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *jpushAlias = [userDefaults valueForKey:kUserjpushalias];
    return jpushAlias;
}
#pragma mark - Setter
- (void)setCurrentRole:(UserRole)currentRole {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(currentRole) forKey:kUserRole];
    [userDefaults synchronize];
    NavigationController *navController = AppDelegate.app.nav;
    MainViewController *parentController = navController.viewControllers[0];
    parentController.tabbar.tabBarDisplayType = currentRole == kUserRoleStudent?MainTabBarDisplayTypeStudent:MainTabBarDisplayTypeTeacher;
    if (self.currentUserID != 0) {
        NSString * tagString = @"";
        if (currentRole == kUserRoleStudent) {
            tagString = @"student";
        } else if (currentRole == kUserRoleTeacher) {
            tagString = @"teacher";
        } else {
            tagString = @"";
        }
        NSString *aliasString = self.currentUserJPushAlias;
        NSSet *tagSet = [NSSet setWithObjects:tagString, nil];
        [JPUSHService setTags:tagSet alias:aliasString fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"----> JPUSH Set tags and alias:\n ResCode=%d, \nTags=%@, \nAlias=%@", iResCode, iTags, iAlias);
        }];
    }
    
    
}
-(void)setCurrentUserAge:(NSInteger)currentUserAge
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(currentUserAge) forKey:kUserAge];
    [userDefaults synchronize];
}
-(void)setCurrentUserCollege:(NSString *)currentUserCollege
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentUserCollege forKey:kUserCollege];
    [userDefaults synchronize];
}
-(void)setCurrentUserGen:(UserGen)currentUserGen
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(currentUserGen) forKey:kUserGen];
    [userDefaults synchronize];
}
-(void)setCurrentUserHeadImageName:(NSString *)currentUserHeadImageName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentUserHeadImageName forKey:kUserHeadImage];
    [userDefaults synchronize];
}
-(void)setCurrentUserID:(NSInteger)currentUserID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(currentUserID) forKey:kUserID];
    [userDefaults synchronize];
}
-(void)setCurrentUserName:(NSString *)currentUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentUserName forKey:kUserName];
    [userDefaults synchronize];
}
-(void)setCurrentUserNickname:(NSString *)currentUserNickname
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentUserNickname forKey:kUserNickname];
    [userDefaults synchronize];
}
-(void)setCurrentUserTelNum:(NSString *)currentUserTelNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentUserTelNum forKey:kUserTel];
    [userDefaults synchronize];
}
-(void)setLastUserTelNum:(NSString *)lastUserTelNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:lastUserTelNum forKey:kUserLastUserTel];
    [userDefaults synchronize];
}
-(void)setCurrentUserInviteCode:(NSString *)currentUserInviteCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:currentUserInviteCode forKey:kUserInviteCode];
    [userDefaults synchronize];
}
-(void)setCurrentUserJPushAlias:(NSString *)currentUserJPushAlias
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setValue:currentUserJPushAlias forKey:kUserjpushalias];
//    [userDefaults synchronize];
    NSString * tagString = @"";
    if (self.currentRole == kUserRoleStudent) {
        tagString = @"student";
    } else if (self.currentRole == kUserRoleTeacher) {
        tagString = @"teacher";
    } else {
        tagString = @"";
    }
    NSSet *tagSet = [NSSet setWithObjects:tagString, nil];
    [JPUSHService setTags:tagSet alias:currentUserJPushAlias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"----> JPUSH Set tags and alias:\n ResCode=%d, \nTags=%@, \nAlias=%@", iResCode, iTags, iAlias);
        if (iResCode == 0) {// register successfully
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setValue:currentUserJPushAlias forKey:kUserjpushalias];
            [userDefaults synchronize];
        } else {
            NSLog(@"----> JPUSH Register alias failed.");
        }
    }];
    
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
        key = [NSString stringWithFormat:@"%@%@",ROLE_STUDENT,keyString];
    } else {
        key = [NSString stringWithFormat:@"%@%@",ROLE_TEACHER,keyString];
    }
    if (key) {
        value = [userDefaults valueForKey:key];
    }
    return value;
}

- (void)logout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:0 forKey:kUserID];
    
    [userDefaults setValue:nil forKey:kUserName];

    [userDefaults setValue:nil forKey:kUserTel];
    
    // Cancel regisgter alias for JPush
    [JPUSHService setTags:nil alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        NSLog(@"----> JPUSH Set tags and alias:\n ResCode=%d, \nTags=%@, \nAlias=%@", iResCode, iTags, iAlias);
        if (iResCode == 0) {// register successfully

            [userDefaults setValue:nil forKey:kUserjpushalias];
            [userDefaults synchronize];
        } else {
            NSLog(@"----> JPUSH Register alias failed.");
        }
    }];
    [userDefaults synchronize];
}
@end
