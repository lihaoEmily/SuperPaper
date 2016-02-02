//
//  PublicationViewTableViewCell.m
//  SuperPaper
//
//  Created by elsie on 16/2/1.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationViewTableViewCell.h"

@implementation PublicationViewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellImg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 7, 55, 55)];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cellImg.frame) + 10, self.cellImg.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 175, 60)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.numberOfLines = 3;
        self.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [self.contentView addSubview:self.cellImg];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end