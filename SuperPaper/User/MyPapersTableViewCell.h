//
//  MyPapersTableViewCell.h
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPapersTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *seperatorLine;

@end
