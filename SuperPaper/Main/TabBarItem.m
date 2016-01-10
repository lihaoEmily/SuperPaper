//
//  ASTabBarItem.m
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "TabBarItem.h"

#pragma mark 随机色
#define kArcColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#pragma mark 自定义颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kLine  1.0f/([UIScreen mainScreen].scale) * 2


@interface TabBarItem ()

@property (strong, nonatomic) UIImage *aSelImage;

@property (strong, nonatomic) UIImage *aImage;

@property (strong, nonatomic) UIImageView *backImageView;

@property (strong, nonatomic) UILabel *aTitleLabel;

@end

@implementation TabBarItem

- (instancetype)initTabbarItemTitle:(NSString *)titleStr image:(NSString *)imageStr selImage:(NSString *)selImageStr {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.showsTouchWhenHighlighted = YES;

        NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources"
                                                              ofType:@"bundle"];
        
        _aSelImage = [UIImage imageNamed:[[NSBundle bundleWithPath:bundleStr] pathForResource:selImageStr
                                                                                       ofType:@"png"
                                                                                  inDirectory:@"tabbar"]];
        
        _aImage = [UIImage imageNamed:[[NSBundle bundleWithPath:bundleStr] pathForResource:imageStr
                                                                                    ofType:@"png"
                                                                               inDirectory:@"tabbar"]];

        
        [self addSubview:self.backImageView];
        
        self.aTitleLabel.text = titleStr;
        [self addSubview:self.aTitleLabel];
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addObserver:self
               forKeyPath:@"selected"
                  options:(NSKeyValueObservingOptionNew) context:nil];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selected"]) {
        if ([change[@"new"] integerValue]) {
            self.backImageView.image = self.aSelImage;
            self.aTitleLabel.textColor = kSelColor;
        } else {
            self.backImageView.image = self.aImage;
            self.aTitleLabel.textColor = [UIColor grayColor];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.aTitleLabel.frame = CGRectMake(0,33 - kLine, self.bounds.size.width, 49 - 33 - kLine);
    self.backImageView.frame = CGRectMake(0, 6 , self.bounds.size.width , 26 );
}


- (UIImageView *)backImageView {
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.backgroundColor = [UIColor clearColor];
        _backImageView.contentMode = UIViewContentModeScaleAspectFit;
        _backImageView.image = self.aImage;
    }
    
    return _backImageView;
}

- (UILabel *)aTitleLabel{
    if (_aTitleLabel == nil) {
        _aTitleLabel = [[UILabel alloc] init];
        _aTitleLabel.backgroundColor = [UIColor whiteColor];
        _aTitleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        _aTitleLabel.backgroundColor = [UIColor clearColor];
        _aTitleLabel.textAlignment = NSTextAlignmentCenter;
        _aTitleLabel.textColor = [UIColor grayColor];
    }
    
    return _aTitleLabel;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
