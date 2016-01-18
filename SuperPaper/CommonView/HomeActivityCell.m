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
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, LEFT_MARGIN, self.bounds.size.width-LEFT_MARGIN*2, 90)];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius  = 10;
    _headImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_MARGIN*2,LEFT_MARGIN * 4, self.bounds.size.width - LEFT_MARGIN * 4, 40)];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 2;
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
