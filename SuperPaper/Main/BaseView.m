//
//  BaseView.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseView.h"

#define TOPBART_VIEW_HEIGHT 44

@interface BaseView()

@property (nonatomic, strong) UIView * topBarView;
@property (nonatomic, strong) UILabel * topBarTitleLabel;
@property (nonatomic, strong) UIButton * rightItemButton;
@property (nonatomic, strong) UIView * contentView;
@end

@implementation BaseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _topBarView = [[UIView alloc] initWithFrame:CGRectZero];
        [_topBarView setBackgroundColor:[UIColor redColor]];
        _topBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_topBarTitleLabel setFont:[UIFont systemFontOfSize:14]];
        _rightItemButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rightItemButton setBackgroundColor:[UIColor clearColor]];
        [_rightItemButton setFrame:CGRectZero];
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)layoutCustomizedView {
    [_topBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintToTop = [NSLayoutConstraint constraintWithItem:_topBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraintToLeft = [NSLayoutConstraint constraintWithItem:_topBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraintToRight = [NSLayoutConstraint constraintWithItem:_topBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *constraintToBottom = [NSLayoutConstraint constraintWithItem:_topBarView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSArray *noDataViewConstraints = [NSArray arrayWithObjects:constraintToTop, constraintToLeft, constraintToRight, constraintToBottom, nil];
    [self addConstraints:noDataViewConstraints];
}


@end
