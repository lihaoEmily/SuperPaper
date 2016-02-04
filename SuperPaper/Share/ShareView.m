//
//  ShareView.m
//  SuperPaper
//
//  Created by Emily on 16/2/2.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

-(void)awakeFromNib
{
    [super awakeFromNib];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, 20)];
    label.text = @"分享到社交平台";
    [self addSubview:label];
    
    _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qqBtn.frame = CGRectMake(10, 50, self.frame.size.width / 4 - 20, self.frame.size.width / 4 - 20);
    _qqBtn.tag = 1000;
    [_qqBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qqBtn setImage:[UIImage imageNamed:@"UMS_qq_icon"] forState:UIControlStateNormal];
    [self addSubview:_qqBtn];
    
    _qZoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _qZoneBtn.frame = CGRectMake(10 + self.frame.size.width / 4 , 50, self.frame.size.width / 4 - 20, self.frame.size.width / 4 - 20);
    _qZoneBtn.tag = 1001;
    [_qZoneBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qZoneBtn setImage:[UIImage imageNamed:@"UMS_qzone_icon"] forState:UIControlStateNormal];
    [self addSubview:_qZoneBtn];
    
    _wechatSessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatSessionBtn.frame = CGRectMake(10 + self.frame.size.width / 4 * 2, 50, self.frame.size.width / 4 - 20, self.frame.size.width / 4 - 20);
    _wechatSessionBtn.tag = 1002;
    [_wechatSessionBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_wechatSessionBtn setImage:[UIImage imageNamed:@"UMS_wechat_icon"] forState:UIControlStateNormal];
    [self addSubview:_wechatSessionBtn];
    
    _wechatSessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatSessionBtn.frame = CGRectMake(10 + self.frame.size.width / 4 * 3, 50, self.frame.size.width / 4 - 20, self.frame.size.width / 4 - 20);
    _wechatSessionBtn.tag = 1003;
    [_wechatTimelineBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_wechatSessionBtn setImage:[UIImage imageNamed:@"UMS_wechat_timeline_icon"] forState:UIControlStateNormal];
    [self addSubview:_wechatSessionBtn];
}

#pragma mark 选择分享按钮点击
- (void)shareBtnClick:(UIButton *)sender
{
    if (_shareDelegate && [_shareDelegate respondsToSelector:@selector(shareBtnClickWithIndex:)]) {
        [_shareDelegate shareBtnClickWithIndex:sender.tag];
    }
}

@end
