//
//  JSTextView.h
//  SuperPaper
//
//  Created by yu on 16/1/27.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSTextView : UITextView
@property(nonatomic,copy) NSString *myPlaceholder;  //文字

@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色
@end
