//
//  UserHeaderView.m
//  SuperPaper
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserHeaderView.h"

@interface UserHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *userImageButton;

@end

@implementation UserHeaderView

- (void)login
{
    if ([self.delegate respondsToSelector:@selector(userHeaderType:)])
    {
        [self.delegate userHeaderType:UserHeaderTypeLogin];
    }
}

- (void)registerButtonAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(userHeaderType:)])
    {
        [self.delegate userHeaderType:UserHeaderTypeRegister];
    }
}

- (void)userImageButtonAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(userHeaderType:)])
    {
        [self.delegate userHeaderType:UserHeaderTypeCamera];
    }
}

- (UIView *)loginView
{
    if (!_loginView)
    {
        _loginView = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil] firstObject];
        [self.registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginView;
}


- (UIView *)normalView
{
    if (!_normalView)
    {
        _normalView = [[[NSBundle mainBundle] loadNibNamed:@"UserHeaderView" owner:self options:nil] lastObject];
        [self.userImageButton addTarget:self action:@selector(userImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _normalView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
