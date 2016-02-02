//
//  PublicationIntroduceView.m
//  SuperPaper
//
//  Created by mapbarios on 16/2/2.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationIntroduceView.h"

@implementation PublicationIntroduceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, TOP_WIEW_HEIGHT)];
//        [_topInfoView setBackgroundColor:[UIColor whiteColor]];
//        [self.view addSubview:_topInfoView];
//        
//        // Left view
//        UIView *leftMarginVew = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 7, TITLE_HEIGHT)];
//        [leftMarginVew setBackgroundColor:kDefaultColor];
//        [_topInfoView addSubview:leftMarginVew];
//        
//        _paperTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftMarginVew.frame) + 15, leftMarginVew.frame.origin.y, kScreenWidth - 30 - leftMarginVew.frame.size.width - 4, TITLE_HEIGHT)];
//        [_paperTitleLabel setText:self.paperTitleStr];
//        [_paperTitleLabel setTextColor:[UIColor blackColor]];
//        [_paperTitleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
//        [_paperTitleLabel setTextAlignment:NSTextAlignmentLeft];
//        [_paperTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//        [_paperTitleLabel setNumberOfLines:2];
//        [_topInfoView addSubview:_paperTitleLabel];
//        
//        // Horizonal separator view
//        UIView *horizontalSepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_paperTitleLabel.frame) + 8, kScreenWidth, 1)];
//        [horizontalSepView setBackgroundColor:[UIColor lightGrayColor]];
//        [_topInfoView addSubview:horizontalSepView];
//        
//        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(horizontalSepView.frame) + 21, 100, 20)];
//        [_dateLabel setText:self.dateStr];
//        [_dateLabel setTextColor:[UIColor grayColor]];
//        [_dateLabel setFont:[UIFont systemFontOfSize:17.0]];
//        [_dateLabel setTextAlignment:NSTextAlignmentLeft];
//        [_topInfoView addSubview:_dateLabel];
//        
//        UIImage *exportImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"txtIcon" ofType:@"png" inDirectory:@"Paper"]];
//        _exportButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 26, CGRectGetMaxY(horizontalSepView.frame) + 18, 26, 26)];
//        [_exportButton setImage:exportImage
//                       forState:UIControlStateNormal];
//        [[_exportButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
//        [_exportButton addTarget:self
//                          action:@selector(exportWebViewToDoc)
//                forControlEvents:UIControlEventTouchUpInside];
//        [_topInfoView addSubview:_exportButton];
//        
//        _exportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_exportButton.frame) - 50, _dateLabel.frame.origin.y, 40, _dateLabel.frame.size.height)];
//        [_exportLabel setText:@"导出:"];
//        [_exportLabel setTextColor:[UIColor blackColor]];
//        [_exportLabel setFont:[UIFont systemFontOfSize:17.0]];
//        [_exportLabel setTextAlignment:NSTextAlignmentRight];
//        [_topInfoView addSubview:_exportLabel];
//        
//        // Bottom separator view
//        UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topInfoView.frame) - 1, kScreenWidth, 1)];
//        [bottomBorderView setBackgroundColor:[UIColor lightGrayColor]];
//        [_topInfoView addSubview:bottomBorderView];
    }
    return self;
}

@end
