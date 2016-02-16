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
    kUserRoleStudent
};
typedef NS_ENUM(NSInteger, UserGen) {
    kUserGen_Man   = 0,
    kUserGen_Woman = 1
};

#pragma mark - Public Keys

#define kUserRole        @"UserRole"
#define kUserName        @"UserName"
#define kUserNickname    @"UserNickname"
#define kUserGen         @"UserGen"
#define kUserAge         @"UserAge"
#define kUserID          @"UserID"
#define kUserHeadImage   @"UserHeadImage"
#define kUserTel         @"UserTel"
#define kUserCollege     @"UserCollege"
#define kUserLastUserTel @"LastUserTel"
#define kUserInviteCode  @"UserInviteCode"
////如还有其实的Key请续断追加

/**
 *  @brief 用户会话，监测用户状态:
 *  1.第一次登录时，会选择【老师】或【学生】登录，请在这时候保存角色
 *  2.应用只能保存一个用户的信息，当有不同用户登录时，要及时更新用户信息（Option）
 *  3.
 */
@interface UserSession : NSObject

#pragma mark - Public Propeties
/**
 *  当前用户角色（老师、学生）
 */
@property (nonatomic, assign) UserRole currentRole;
/**
 *  当前用户id，0表示用户不存在
 */
@property (nonatomic ,assign) NSInteger currentUserID;
/**
 *  当前用户昵称
 */
@property (nonatomic, copy) NSString *currentUserNickname;
/**
 *  当前用户头像名称
 */
@property (nonatomic, copy) NSString *currentUserHeadImageName;
/**
 *  当前用户电话
 */
@property (nonatomic ,copy) NSString *currentUserTelNum;
/**
 *  当前用户性别
 */
@property (nonatomic ,assign) UserGen currentUserGen;
/**
 *  当前用户姓名
 */
@property (nonatomic, strong) NSString *currentUserName;
/**
 *  当前用户年龄
 */
@property (nonatomic ,assign) NSInteger currentUserAge;
/**
 *  当前用户学校名称
 */
@property (nonatomic, copy) NSString *currentUserCollege;
/**
 *  上一个用户电话（相当于缓存）
 */
@property (nonatomic, copy) NSString *lastUserTelNum;
/**
 *  当前用户自己的邀请码
 */
@property (nonatomic ,copy) NSString *currentUserInviteCode;
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
/**
 *  当前用户退出登录
 */
- (void)logout;
@end
