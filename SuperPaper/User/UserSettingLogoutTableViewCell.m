//
//  UserSettingLogoutTableViewCell.m
//  SuperPaper
//
//  Created by yu on 16/1/23.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserSettingLogoutTableViewCell.h"
#import "SettingViewController.h"

@implementation UserSettingLogoutTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.logoutBtn.layer.masksToBounds = YES;
    self.logoutBtn.layer.cornerRadius = 4;
    self.logoutBtn.backgroundColor = [AppConfig appNaviColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)logout:(id)sender {
    [self.superVC performSelector:@selector(logout)];
}

@end
