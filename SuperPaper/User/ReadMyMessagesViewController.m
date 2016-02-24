//
//  ReadMyMessagesViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/25.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ReadMyMessagesViewController.h"
#import "ShareManage.h"
#import "UMSocial.h"
#import "ShareView.h"

@interface ReadMyMessagesViewController ()<UMSocialUIDelegate>
{
    UIActivityIndicatorView *_webIndicator;
    NSDictionary *_textAttributeDictionary;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ReadMyMessagesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIFont *font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 15; // 首行字间矩
    paragraphStyle.headIndent = 15; // 字间矩
    paragraphStyle.lineSpacing = 7; // 行间矩
    _textAttributeDictionary = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareThisMessage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.textView.textContainerInset = UIEdgeInsetsMake(8, 16, 8, 16);
    self.title = self.messageTitle;
    NSString * htmlString = self.messageContent;
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr setAttributes:_textAttributeDictionary range:NSMakeRange(0, attrStr.length)];
    self.textView.attributedText = attrStr;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@readusernotice.php",BASE_URL];
    NSDictionary *params = @{@"id":@(self.messageID)};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    }];
    [_webIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
}
//MARK: 功能
- (void) shareThisMessage
{
    //TODO: 分享我的信息
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56af0b3be0f55ab9b1001511"
                                      shareText:@"更多精彩内容尽在[超级论文]"
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
    
    // 分享的图片
    UIImage *image = [UIImage imageNamed:@"LOGO-181"];
    
    // 微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.fileData = UIImagePNGRepresentation(image);
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlString;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = image;
    
    // 微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.fileData = UIImagePNGRepresentation(image);
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = image;
    
    // QQ好友
    [UMSocialData defaultData].extConfig.qqData.url = self.urlString;
    [UMSocialData defaultData].extConfig.qqData.title = self.title;
    [UMSocialData defaultData].extConfig.qqData.shareImage = image;
    
    // QQ空间
    [UMSocialData defaultData].extConfig.qzoneData.url = self.urlString;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.title;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = image;
}

#pragma mark - UMSocialUIDelegate
- (BOOL)isDirectShareInIconActionSheet {
    return YES;
}

-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    NSLog(@"%s", __func__);
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType {
    NSLog(@"---->UMSViewControllerType : %u",fromViewControllerType);
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
