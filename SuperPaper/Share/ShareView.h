//
//  ShareView.h
//  SuperPaper
//
//  Created by Emily on 16/2/2.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shareCustomDelegate <NSObject>      //协议

@required

- (void)shareBtnClickWithIndex:(NSInteger)tag;

@end

@interface ShareView : UIView

@property (nonatomic, strong) UIButton *qqBtn;
@property (nonatomic, strong) UIButton *qZoneBtn;
@property (nonatomic, strong) UIButton *wechatSessionBtn;
@property (nonatomic, strong) UIButton *wechatTimelineBtn;

// 代理
@property(nonatomic,retain)id<shareCustomDelegate> shareDelegate;

@end
