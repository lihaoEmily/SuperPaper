//
//  HomeActivityCell.m
//  SuperPaper
//
//  Created by 瞿丹丹 on 16/1/16.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "HomeActivityCell.h"

#define LEFT_MARGIN (5.0)

@implementation HomeActivityCell
{
    UIImageView *_headImageView;
    UILabel* _titleLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self creatUI];
        
    }
    return self;
}


- (void)creatUI{
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, LEFT_MARGIN, OWIDTH-LEFT_MARGIN*2, 130)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius  = 10;
    [self.contentView addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN*2,LEFT_MARGIN * 4, OWIDTH - LEFT_MARGIN * 4, 60)];
    _titleLabel.font = [UIFont systemFontOfSize:17.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_titleLabel];
    
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    [_headImageView sd_setImageWithURL:infoDict[@"image"] placeholderImage:[UIImage imageNamed:@""]];
    _titleLabel.text = infoDict[@"title"];
    [_titleLabel sizeToFit];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
