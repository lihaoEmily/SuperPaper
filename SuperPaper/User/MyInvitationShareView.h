//
//  MyInvitationShareView.h
//  SuperPaper
//
//  Created by  mapbar_ios on 16/2/3.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol shareCustomDelegate <NSObject>      //协议

@required

- (void)shareBtnClickWithIndex:(NSInteger)tag;

@end


@interface MyInvitationShareView : UIView
@property (nonatomic ,copy) NSString *shareString;
@property(nonatomic,retain)id<shareCustomDelegate> shareDelegate;
@end
