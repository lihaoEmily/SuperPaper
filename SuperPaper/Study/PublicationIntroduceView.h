//
//  PublicationIntroduceView.h
//  SuperPaper
//
//  Created by mapbarios on 16/2/2.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@interface PublicationIntroduceView : BaseView

/**
 *  论文标题
 */
@property(nonatomic, strong) UILabel* publicationTitleLabel;
/**
 *  顶部View
 */
@property(nonatomic, strong) UIView   * topInfoView;
/**
 *  投稿提示
 */
@property(nonatomic, strong) UILabel  * contributeLabel;

@end
