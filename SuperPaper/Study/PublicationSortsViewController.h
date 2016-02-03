//
//  PublicationSortsViewController.h
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"

@protocol ClassifiedPublicationViewControllerDelegate

-(void)searchByTagid:(NSInteger) tagId;

@end


@interface PublicationSortsViewController : BaseViewController

@property (nonatomic ,assign)NSInteger tagId;
@property (nonatomic ,assign)NSInteger groupId;
@property (nonatomic ,weak)id<ClassifiedPublicationViewControllerDelegate> delegate;

@end