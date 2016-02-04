//
//  QRCodesController.m
//  二维码
//
//  Created by admin on 16/1/21.
//  Copyright © 2016年 AppStudio. All rights reserved.
//

#import "QRCodesController.h"
#import <AVFoundation/AVFoundation.h>
#define kTextLabel @"将二维码放入框内，即可自动扫描"




@interface QRCodesController () <AVCaptureMetadataOutputObjectsDelegate>
{
    NSTimer *timer;
}
@property (nonatomic,strong) UIImageView *cameraImageView;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIImageView *lineImageView;

@property (nonatomic,strong) AVCaptureDevice *device;
@property (nonatomic,strong) AVCaptureDeviceInput *input;
@property (nonatomic,strong) AVCaptureMetadataOutput *output;
@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *preview;

@end

@implementation QRCodesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.title = @"扫一扫";
    
    self.cameraImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    CGRect cameraRect = self.cameraImageView.frame;
    [self.view addSubview:self.cameraImageView];
    _preview.frame = self.cameraImageView.frame;

    
    UIImage *image = [UIImage imageWithASName:@"lineView" directory:@"user"];
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cameraRect.origin.x, cameraRect.origin.y, cameraRect.size.width, 1)];
    self.lineImageView.image = image;
    [self.view addSubview:self.lineImageView];
    
    self.textLabel.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.cameraImageView.frame)+ self.textLabel.frame.size.height );
    [self.view addSubview:self.textLabel];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(lineAnimation:) userInfo:nil repeats:YES];

    [self lineAnimation:timer];
    
    [self setCamera];
    
}

- (void)setCamera{
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode] ;

    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)lineAnimation:(NSTimer *)aTimer
{

    CGRect cameraRect = self.cameraImageView.frame;
    
    UIImageView *imageV = self.lineImageView;
    imageV.frame = CGRectMake(cameraRect.origin.x, cameraRect.origin.y, cameraRect.size.width, 1);
    
    [UIView animateWithDuration:2 animations:^{
        
        imageV.frame = CGRectMake(cameraRect.origin.x, CGRectGetMaxY(cameraRect), cameraRect.size.width, 1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 animations:^{
         
            imageV.frame = CGRectMake(cameraRect.origin.x, cameraRect.origin.y, cameraRect.size.width, 1);
            
        }];
    }];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [timer invalidate];
    [_session stopRunning];
    if (metadataObjects.count > 0 )
    {
        NSString *resultStr = [[metadataObjects firstObject] stringValue];
        if (self.ScanResult) {
            self.ScanResult(resultStr,YES);
        }
    }else
    {
        self.ScanResult(@"false",NO);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.cameraImageView.center = self.view.center;
//    self.textLabel.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.cameraImageView.frame)+ self.textLabel.frame.size.height );
    
    _preview.frame = self.cameraImageView.frame;

}


+ (BOOL)isCameraAvailable
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return YES;
    }else{
        return NO;
    }
}

- (UIImageView *)cameraImageView
{
    if (!_cameraImageView)
    {
        _cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithASName:@"cameraImage" directory:@"user"]];
        _cameraImageView.frame = CGRectMake(0, 0, 200, 200);
        _cameraImageView.clipsToBounds = YES;
        _cameraImageView.clipsToBounds = YES;
    }
    
    return _cameraImageView;
}

- (UILabel *)textLabel
{
    if (!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = kTextLabel;
        _textLabel.textColor = [UIColor whiteColor];
        CGSize size = [QRCodesController sizeWithFont:_textLabel.font textStr:_textLabel.text];
        _textLabel.frame = CGRectMake(0, 0, size.width, size.height);
    }
    
    return _textLabel;
}


// 消除警告 方法不能使用的警告，方法已经过滤，所以不需要警告。
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (CGSize)sizeWithFont:(UIFont *)font textStr:(NSString *)textStr
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0) {
        return [textStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    } else {
        return [textStr sizeWithFont:font constrainedToSize:maxSize];
    }
}

#pragma clang diagnostic pop

- (void)dealloc
{
    
    [timer invalidate];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
