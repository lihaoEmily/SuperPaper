//
//  PublicationView.m
//  SuperPaper
//
//  Created by elsie on 16/1/27.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationView.h"

@interface PublicationView ()



@end

@implementation PublicationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.frame = CGRectMake(0, 0, self.bounds.size.width/4, self.bounds.size.height);
        //    _leftTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _leftTableView.showsVerticalScrollIndicator = NO;
        //    _leftTable.tableFooterView = [[UIView alloc] init];
        _leftTableView.tag = 1000;
        _leftTableView.separatorColor = [UIColor whiteColor];
        _leftTableView.allowsSelection = YES;
        _leftTableView.allowsMultipleSelection = NO;
        [self addSubview:_leftTableView];
        
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.frame = CGRectMake(self.bounds.size.width/4, 0, self.bounds.size.width*3/4, self.bounds.size.height);
        _rightTableView.showsVerticalScrollIndicator = YES;
        _rightTableView.tag = 2000;
        _rightTableView.allowsSelection = YES;
        _rightTableView.allowsMultipleSelection = NO;
        [self addSubview:_rightTableView];
    }
    return self;
}

@end

