//
//  ShareManage.h
//  SuperPaper
//
//  Created by Emily on 16/2/1.
//  Copyright © 2016年 Share technology. All rights reserved.
//  分享管理

// 友盟APIKey
#define UMeng_APIKey        @"56af0b3be0f55ab9b1001511"
#define WX_APP_KEY          @"wx1bb4e3dee024af61"
#define WX_APP_SECRET       @"513ad74a27c611b9afac24f3226b897d"
#define QQ_APP_KEY          @"1105051018"
#define QQ_APP_SECRET       @"qqWTYTx2Yhh8q82R"
#define share_title         @"渠道系统APP下载地址共享"
#define share_content       @"更多精彩内容尽在[超级论文]"
#define share_url           @""

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ShareManage : NSObject <MFMessageComposeViewControllerDelegate>
+ (ShareManage *)shareManage;

- (void)shareConfig;

/**微信好友分享**/
- (void)wxShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title;

/**微信朋友圈分享**/
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title;

/**QQ好友分享**/
- (void)QQFriendsShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title;

/**QQ空间分享**/
- (void)QzoneShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title;

/**短信分享**/
- (void)smsShareWithViewControll:(UIViewController *)viewC;

/**新浪微博分享**/
- (void)wbShareWithViewControll:(UIViewController *)viewC;
@end
