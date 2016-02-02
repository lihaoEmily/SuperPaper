//
//  PublicationIntroduceViewController.h
//  SuperPaper
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PublicationDetailData : NSObject

@property (nonatomic, assign) NSInteger result;
@property (nonatomic, strong) NSString* selftitle;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* keywords;
@property (nonatomic, assign) NSInteger viewnum;
@property (nonatomic, strong) NSString* content_pic_name;
@property (nonatomic, strong) NSString* createdate;
@property (nonatomic, assign) NSInteger emptyflg;
@property (nonatomic, strong) NSString* tel;

@end


@interface PublicationIntroduceViewController : BaseViewController

@property (nonatomic,assign) NSInteger publicationID;

@end
