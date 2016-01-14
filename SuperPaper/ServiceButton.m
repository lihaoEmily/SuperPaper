//
//  ServiceButton.m
//  SuperPaper
//
//  Created by wangli on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ServiceButton.h"

#define MARGIN  (self.bounds.size.width/10) //文字和图片的间隔

@interface ServiceButton ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation ServiceButton

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 控件大小,间距大小
    CGFloat const imageViewEdge   = self.bounds.size.width * 0.4;
    CGFloat const centerOfView    = self.bounds.size.width * 0.5;
    CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
    CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge - MARGIN;
    CGFloat const verticalMargin  = verticalMarginT / 2;
    
    // imageView 和 titleLabel 中心的 Y 值
    CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.5;
    CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin + MARGIN + labelLineHeight * 0.5;
    
    //imageView position 位置
    self.imageView.bounds = CGRectMake(0, 0, imageViewEdge, imageViewEdge);
    self.imageView.center = CGPointMake(centerOfView, centerOfImageView);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //title position 位置
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, labelLineHeight);
    self.titleLabel.center = CGPointMake(centerOfView, centerOfTitleLabel);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 控件大小,间距大小
        CGFloat const imageViewEdge   = self.bounds.size.width * 0.4;
        CGFloat const centerOfView    = self.bounds.size.width * 0.5;
        CGFloat const labelLineHeight = self.titleLabel.font.lineHeight;
        CGFloat const verticalMarginT = self.bounds.size.height - labelLineHeight - imageViewEdge - MARGIN;
        CGFloat const verticalMargin  = verticalMarginT / 2;
        
        // imageView 和 titleLabel 中心的 Y 值
        CGFloat const centerOfImageView  = verticalMargin + imageViewEdge * 0.5;
        CGFloat const centerOfTitleLabel = imageViewEdge  + verticalMargin + MARGIN + labelLineHeight * 0.5;
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageViewEdge, imageViewEdge)];
        _icon.center = CGPointMake(centerOfView, centerOfImageView);
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_icon];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, labelLineHeight)];
        _titleLbl.center = CGPointMake(centerOfView, centerOfTitleLabel);
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = [UIFont systemFontOfSize:15];
        [self addSubview:_titleLbl];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
}

- (void)setLabelTitle:(NSString *)labelTitle{
    _labelTitle = labelTitle;
    _titleLbl.text = _labelTitle;
}


@end
