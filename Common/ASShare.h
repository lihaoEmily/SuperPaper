//
//  ASShare.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/21.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>
//add share sdk
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface ASShare : NSObject

+ (void)commonShareWithData:(NSArray *)sharedInfo;

@end
