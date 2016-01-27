//
//  ProfileSubmitTableViewCell.h
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/25.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfoViewController.h"
@interface ProfileSubmitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak ,nonatomic) PersonalInfoViewController *superController;
@end
