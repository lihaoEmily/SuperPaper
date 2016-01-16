//
//  UserSession.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserRole){
    kUserRoleDefault = 0,
    kUserRoleTeacher = 1,
    kUserRoleStudent = 2
};

/**
 *  @brief 用户会话，监测用户状态:
 *  1.第一次登录时，会选择【老师】或【学生】登录，请在这时候保存角色
 *  2.应用只能保存一个用户的信息，当有不同用户登录时，要及时更新用户信息（Option）
 *  3.
 */
@interface UserSession : NSObject
#pragma mark - Public Keys
/**
 *  用户角色 Key
 */
FOUNDATION_EXTERN NSString *const kUserRole;
/**
 *  用户名 Key
 */
FOUNDATION_EXTERN NSString *const kUserName;
/**
 *  用户ID Key
 */
FOUNDATION_EXTERN NSString *const kUserID;
/**
 *  用户电话 Key
 */
FOUNDATION_EXTERN NSString *const kUserTel;
/**
 *  用户Token Key
 */
FOUNDATION_EXTERN NSString *const kUserToken;
//如还有其实的Key请续断追加

#pragma mark - Public Propeties
/**
 *  用户角色（老师、学生）
 */
@property (nonatomic, assign) UserRole currentRole;
/**
 *  当前用户
 */
@property (nonatomic, strong) NSString *currentUser;
/**
 *  是否已经登录
 */
@property (nonatomic, assign) BOOL hasLogin;
/**
 *  是否已经注册
 */
@property (nonatomic, assign) BOOL hasRegisgered;

#pragma mark - Public Methods
/**
 *  用户信息Session
 *
 *  @return 用户Session单例
 */
+ (UserSession *)sharedInstance;

/**
 *  保存当前用户的信息
 *
 *  @param infoDic 用户信息字典
 */
- (void)saveUserProfileWithInfo:(NSDictionary *)infoDic;

/**
 *  获取当前用户的信息
 *
 *  @param keyString 用户信息键值
 *
 *  @return 用户信息数据
 */
- (id)currentUserProfileForKey:(NSString *)keyString;

@end
