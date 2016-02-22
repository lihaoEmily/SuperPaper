//
//  HomeNewsCell.m
//  SuperPaper
//
//  Created by 瞿丹丹 on 16/1/16.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "HomeNewsCell.h"
#import "UIImageView+WebCache.h"

#define LEFT_MARGIN (8.0)

@implementation HomeNewsCell
{
    UIImageView *_headImageView;
    UILabel* _titleLabel;
    UILabel *_timeLabel;//详情
}
- (void)awakeFromNib {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
        [self creatUI];

    }
    return self;
}


- (void)creatUI{
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_MARGIN*2, LEFT_MARGIN*2, 100, 68)];
//    _headImageView.layer.masksToBounds = YES;
//    _headImageView.layer.cornerRadius  = 10;
    [self.contentView addSubview:_headImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + LEFT_MARGIN*3,
                                                            LEFT_MARGIN*2,
                                                            SCREEN_WIDTH - CGRectGetMaxX(_headImageView.frame) - LEFT_MARGIN * 6,
                                                            48)];
    _titleLabel.font = [UIFont systemFontOfSize:18.0];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame),
                                                           CGRectGetMaxY(_titleLabel.frame),
                                                           SCREEN_WIDTH - CGRectGetMaxX(_headImageView.frame) - LEFT_MARGIN * 2 ,
                                                           20)];
    _timeLabel.font = [UIFont systemFontOfSize:14.0];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
}

-(void)setInfoDict:(NSDictionary *)infoDict
{
    [_headImageView sd_setImageWithURL:infoDict[@"image"]
                      placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
    _titleLabel.text = infoDict[@"title"];
    [_titleLabel sizeToFit];
    CGSize detailmaxSize = CGSizeMake(SCREEN_WIDTH - CGRectGetMaxX(_headImageView.frame) - LEFT_MARGIN * 5, 40);
    CGSize detailSize = [_titleLabel sizeThatFits:detailmaxSize];
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_headImageView.frame) + LEFT_MARGIN * 3,LEFT_MARGIN*2 , detailSize.width, detailSize.height);
    _timeLabel.text = infoDict[@"time"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
