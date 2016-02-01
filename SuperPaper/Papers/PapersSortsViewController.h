//
//  PapersSortsViewController.h
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"
@protocol ClassifiedPapersViewControllerDelegate
-(void)passTypeId:(NSString *)typeId;
@end
@interface PapersSortsViewController : BaseViewController

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,copy)NSString * typeId;
@property (nonatomic ,weak)id<ClassifiedPapersViewControllerDelegate> delegate;
@end
