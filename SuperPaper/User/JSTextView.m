//
//  JSTextView.m
//  SuperPaper
//
//  Created by yu on 16/1/27.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "JSTextView.h"
@interface JSTextView()
@property (nonatomic,weak) UILabel *placeholderLabel;
@end
@implementation JSTextView
-(void)awakeFromNib
{
    [super awakeFromNib];
    UILabel *placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 2, self.bounds.size.width - 10, 21)];//添加一个占位label
    
    placeholderLabel.backgroundColor = [UIColor clearColor];
    
    placeholderLabel.numberOfLines = 0;
    
    placeholderLabel.font = self.font;
    
    [self addSubview:placeholderLabel];
    
    self.placeholderLabel = placeholderLabel; //赋值保存
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
}

- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize maxSize = CGSizeMake(self.placeholderLabel.bounds.size.width,MAXFLOAT);
    
    CGFloat height = [self.myPlaceholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    self.placeholderLabel.frame = CGRectMake(10, 2, self.bounds.size.width - 20, height);
}
- (void)setMyPlaceholder:(NSString*)myPlaceholder{
    
    _myPlaceholder= [myPlaceholder copy];
    
    //设置文字
    
    self.placeholderLabel.text= myPlaceholder;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}

- (void)setMyPlaceholderColor:(UIColor*)myPlaceholderColor{
    
    _myPlaceholderColor= myPlaceholderColor;
    
    //设置颜色
    
    self.placeholderLabel.textColor= myPlaceholderColor;
    
}


- (void)setFont:(UIFont*)font {
    
    [super setFont:font];
    
    self.placeholderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}
- (void)setText:(NSString*)text{
    NSLog(@"进到jstextview");
    [super setText:text];
    
    [self textDidChange];
    
}

- (void)setAttributedText:(NSAttributedString*)attributedText {
    
    [super setAttributedText:attributedText];
    
    [self textDidChange];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
