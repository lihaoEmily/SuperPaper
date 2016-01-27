//
//  ReadMyMessagesViewController.h
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/25.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadMyMessagesViewController : UIViewController
@property (nonatomic) NSInteger messageID;
@property (nonatomic, copy) NSString *messageContent;
@property (nonatomic, copy) NSString *messageTitle;
@end
