//
//  UserSettingLogoutTableViewCell.h
//  SuperPaper
//
//  Created by yu on 16/1/23.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingViewController;
@interface UserSettingLogoutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;
@property (weak, nonatomic) SettingViewController *superVC;
@end
