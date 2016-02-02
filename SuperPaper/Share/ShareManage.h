//
//  ShareManage.h
//  KONKA_MARKET
//
//  Created by wxxu on 14/12/18.
//  Copyright (c) 2014年 archon. All rights reserved.
//  分享管理

// 友盟APIKey
#define UMeng_APIKey        @"56af0b3be0f55ab9b1001511"
#define WX_APP_KEY          @"wxd930ea5d5a258f4f"
#define WX_APP_SECRET       @"db426a9829e4b49a0dcac7b4162da6b6"
#define QQ_APP_KEY          @"1104770869"
#define QQ_APP_SECRET       @"GBjkYtbypyf8uQHW"
#define share_title         @"渠道系统APP下载地址共享"
#define share_content       @"更多精彩内容尽在[超级论文]"
#define share_url           @"http://qdgl.konka.com/files/konka/appdownloadofwap/index_wap.html"

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface ShareManage : NSObject <MFMessageComposeViewControllerDelegate>
+ (ShareManage *)shareManage;

- (void)shareConfig;

/**微信分享**/
- (void)wxShareWithViewControll:(UIViewController *)viewC;

/**新浪微博分享**/
- (void)wbShareWithViewControll:(UIViewController *)viewC;

/**微信朋友圈分享**/
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC;

/**短信分享**/
- (void)smsShareWithViewControll:(UIViewController *)viewC;

/**QQ空间分享**/
- (void)QzoneShareWithViewControll:(UIViewController *)viewC;

/**QQ好友分享**/
- (void)QQFriendsShareWithViewControll:(UIViewController *)viewC;
@end
