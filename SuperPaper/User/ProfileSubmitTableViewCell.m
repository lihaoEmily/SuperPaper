//
//  ProfileSubmitTableViewCell.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/25.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ProfileSubmitTableViewCell.h"

@implementation ProfileSubmitTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.backgroundColor = [AppConfig appNaviColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submit:(id)sender {
    [self.superController performSelector:@selector(submit)];
}

@end
