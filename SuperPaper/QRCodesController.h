//
//  QRCodesController.h
//  二维码
//
//  Created by admin on 16/1/21.
//  Copyright © 2016年 AppStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 if ([QRCodesController isCameraAvailable])
 {
 QRCodesController *qr = [[QRCodesController alloc] init];
 [self.navigationController pushViewController:qr animated:YES];
 qr.ScanResult = ^(NSString *result,BOOL isSucceed){
 
 if (isSucceed)
 {
 NSLog(@"在这里处理结果 %@",result);
 
 }
 
 };
 }else
 {
 NSLog(@"请开启摄像头");
 }
 */

@interface QRCodesController : UIViewController

@property (nonatomic,copy) void(^ScanResult)(NSString*result,BOOL isSucceed);

/*
 *  判断摄像头是否有效
 */
+ (BOOL)isCameraAvailable;

@end
