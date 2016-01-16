//
//  UserHeaderView.h
//  SuperPaper
//
//  Created by admin on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    
    UserHeaderTypeLogin,
    UserHeaderTypeRegister,
    UserHeaderTypeCamera
    
}UserHeaderType;


@protocol UserHeaderViewDelegate;

@interface UserHeaderView : NSObject

@property (weak, nonatomic) IBOutlet UILabel *telephoneNumLabel;
@property (nonatomic,strong) UIView *loginView;
@property (nonatomic,strong) UIView *normalView;

@property (nonatomic,weak) id<UserHeaderViewDelegate>  delegate;

@end


@protocol UserHeaderViewDelegate <NSObject>

- (void)userHeaderType:(UserHeaderType)type;

@end