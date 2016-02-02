//
//  ShareManage.m
//  KONKA_MARKET
//
//  Created by wxxu on 14/12/18.
//  Copyright (c) 2014年 archon. All rights reserved.
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

#pragma mark 微信分享
- (void)wxShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
    
    [UMSocialWechatHandler setWXAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:share_url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 新浪微博分享
- (void)wbShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark 微信朋友圈分享
- (void)wxpyqShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
    [UMSocialWechatHandler setWXAppId:WX_APP_KEY appSecret:WX_APP_SECRET url:share_url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark QQ空间分享
- (void)QzoneShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
    [UMSocialQQHandler setQQWithAppId:QQ_APP_KEY appKey:QQ_APP_SECRET url:share_url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark QQ好友分享
- (void)QQFriendsShareWithViewControll:(UIViewController *)viewC
{
    _viewC = viewC;
    [[UMSocialControllerService defaultControllerService] setShareText:share_content shareImage:nil socialUIDelegate:nil];
    [UMSocialQQHandler setQQWithAppId:QQ_APP_KEY appKey:QQ_APP_SECRET url:share_url];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(viewC,[UMSocialControllerService defaultControllerService],YES);
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
