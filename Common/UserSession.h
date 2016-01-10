//
//  UserSession.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserRole){
    kUserRoleTeacher = 1,
    kUserRoleStudent = 2
};

@interface UserSession : NSObject

@property (nonatomic, strong) NSString *currentUserRole;
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) BOOL hasRegisgered;

+ (UserSession *)sharedInstance;

@end
