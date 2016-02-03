//
//  MyInvitationShareView.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/2/3.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MyInvitationShareView.h"
#import "AppConfig.h"
@interface MyInvitationShareView()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MyInvitationShareView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.topView.layer.borderColor = [AppConfig appNaviColor].CGColor;
    self.topView.layer.borderWidth = 1;
    self.bottomView.layer.borderWidth = 1;
    self.bottomView.layer.borderColor = [AppConfig appNaviColor].CGColor;
    self.contentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentLabel.layer.borderWidth = 0.5;
    
    
}
- (IBAction)shareToSocailPlatform:(UIButton *)sender {
    if (_shareDelegate && [_shareDelegate respondsToSelector:@selector(shareBtnClickWithIndex:)]) {
        [_shareDelegate shareBtnClickWithIndex:sender.tag];
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentLabel.text = self.shareString;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
