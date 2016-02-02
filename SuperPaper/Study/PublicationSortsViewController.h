//
//  PublicationSortsViewController.h
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"

@protocol ClassifiedPublicationViewControllerDelegate

-(void)passTypeId:(NSInteger) typeId;

@end

@interface PublicationSortsViewController : BaseViewController

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,assign)NSInteger typeId;
@property (nonatomic ,weak)id<ClassifiedPublicationViewControllerDelegate> delegate;

@end