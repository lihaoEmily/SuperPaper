//
//  ShareManage.m
//  SuperPaper
//
//  Created by Emily on 16/2/1.
//  Copyright © 2016年 Share technology. All rights reserved.
//  分享管理

#import "ShareManage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "WXApi.h"
#import "UMSocialQQHandler.h"

@implementation ShareManage {
    UIViewController *_viewC;
}

static ShareManage *shareManage;

+ (ShareManage *)shareManage
{
    @synchronized(self)
    {
        if (shareManage == nil) {
            shareManage = [[self alloc] init];
        }
        return shareManage;
    }
}

#pragma mark 注册友盟分享微信
- (void)shareConfig
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMeng_APIKey];
    [UMSocialData openLog:YES];
    
    //注册微信
    [WXApi registerApp:WX_APP_KEY];
    //设置图文分享
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
}

#pragma mark 微信好友分享
- (void)wxShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title
{
    _viewC = viewC;
    UIImage *image = [UIImage imageNamed:@"LOGO-181"];
    [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:nil];
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialWechatHandler setWXAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:urlString];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 微信朋友圈分享
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title
{
    _viewC = viewC;
    UIImage *image = [UIImage imageNamed:@"LOGO-181"];
    [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:nil];
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialWechatHandler setWXAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:urlString];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark QQ好友分享
- (void)QQFriendsShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title
{
    _viewC = viewC;
    UIImage *image = [UIImage imageNamed:@"LOGO-181"];
    [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:nil];
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialQQHandler setQQWithAppId:QQ_APP_KEY appKey:QQ_APP_SECRET url:urlString];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark QQ空间分享
- (void)QzoneShareWithViewControll:(UIViewController *)viewC text:(NSString *)text urlString:(NSString *)urlString title:(NSString *)title
{
    _viewC = viewC;
    UIImage *image = [UIImage imageNamed:@"LOGO-181"];
    [[UMSocialControllerService defaultControllerService] setShareText:text shareImage:image socialUIDelegate:nil];
    [UMSocialData defaultData].extConfig.qzoneData.title = title;
    [UMSocialQQHandler setQQWithAppId:QQ_APP_KEY appKey:QQ_APP_SECRET url:urlString];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 短信分享
- (void)smsShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }
        else {
            //@"设备没有短信功能"
        }
    }
    else {
        //@"iOS版本过低,iOS4.0以上才支持程序内发送短信"
    }
}

#pragma mark 新浪微博分享
- (void)wbShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 短信的代理方法
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [_viewC dismissViewControllerAnimated:YES completion:nil];
    switch (result)
    {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultSent:
            //@"感谢您的分享!"
            break;
        case MessageComposeResultFailed:
            
            break;
        default:
            break;
    }
}

- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = [UIColor blackColor];
    //    picker.recipients = [NSArray arrayWithObject:@"10086"];
    picker.body = share_content;
    [_viewC presentViewController:picker animated:YES completion:nil];
}
@end
