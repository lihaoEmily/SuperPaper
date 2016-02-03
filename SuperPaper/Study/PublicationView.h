//
//  PublicationView.h
//  SuperPaper
//
//  Created by elsie on 16/1/27.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit+AFNetworking.h"
#import "BaseView.h"

@interface PublicationView : BaseView

@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;

@property (nonatomic, strong) NSDictionary *infoDic;

@end