//
//  ChangeUserHeadImageViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/23.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ChangeUserHeadImageViewController.h"
#import "ChangeUserHeadImageHasNextTableViewCell.h"
#import "ChangeUserHeadImageTextShowTableViewCell.h"
#import "UserSession.h"
#import "AppConfig.h"


@interface ChangeUserHeadImageViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UITextField *_nickNameTextField;
    UIView *_popupView;
    UIActivityIndicatorView *_webIndicator;
    UIView *_inputView;
    CGRect _originalFrame;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *const HasNextIdentifier = @"hasnext";
static NSString *const ShowTextIdentifier = @"showtext";
@implementation ChangeUserHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    
    _webIndicator = indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
//MARK: UITableViewDataSource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        ChangeUserHeadImageHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleImageView.image = [UIImage imageNamed:@"更换头像"];
        cell.titleLabel.text = @"头像上传";
        cell.contentLabel.text = nil;
        return cell;
        
    }else if(1 == indexPath.row){
        ChangeUserHeadImageHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleImageView.image = [UIImage imageNamed:@"昵称"];
        cell.titleLabel.text = @"昵称";
        cell.contentLabel.text = [UserSession sharedInstance].currentUserNickname;
        return cell;
        
    }else{
        ChangeUserHeadImageTextShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowTextIdentifier];
        cell.contentLabel.text = [UserSession sharedInstance].currentUserTelNum;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.row) {
        [self popupChangeNickNameView];
    }else if(0 == indexPath.row){
        [self popupChangeHeadImageView];
    }
}

//MARK: Helper
//键盘弹出
- (void)keyboardShow:(NSNotification *)noti
{
    
    _originalFrame = _inputView.frame;
    
    NSDictionary *info  = noti.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [_popupView convertRect:rawFrame fromView:nil];
    CGFloat moveDistance = keyboardFrame.origin.y - CGRectGetMaxY(_originalFrame);
    if (CGRectGetMaxY(_originalFrame) > keyboardFrame.origin.y) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]animations:^{
            _inputView.frame =  CGRectOffset(_inputView.frame, 0, moveDistance);
        } completion:nil];
    }
    
    
}
//键盘收起
- (void)keyboardHide:(NSNotification *)noti
{
    
    if (_originalFrame.origin.y > _inputView.frame.origin.y) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]animations:^{
            _inputView.frame =  CGRectOffset(_inputView.frame, 0, _originalFrame.origin.y - _inputView.frame.origin.y);
        } completion:nil];
    }
    
}


- (void) popupChangeHeadImageView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    CGSize size = [UIScreen mainScreen].bounds.size;//屏幕尺寸
    UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, size.height - 200, size.width - 50, 45)];
    [cameraBtn setTitle:@"拍 照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cameraBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cameraBtn setBackgroundColor:[UIColor whiteColor]];
    [cameraBtn addTarget:self action:@selector(chooseHeadImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cameraBtn];
    
    UIButton *photoLibraryBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, size.height - 140, size.width - 50, 45)];
    [photoLibraryBtn setTitle:@"从相册选择" forState:UIControlStateNormal];
    [photoLibraryBtn setTitleColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1] forState:UIControlStateNormal];
    [photoLibraryBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [photoLibraryBtn setBackgroundColor:[UIColor whiteColor]];
    [photoLibraryBtn addTarget:self action:@selector(chooseHeadImageFromPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:photoLibraryBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, size.height - 80, size.width - 50, 45)];
    [cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn addTarget:self action:@selector(dismissPopupView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    _popupView = bgView;
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
}

- (void) chooseHeadImageFromCamera
{
    [self startCamerControllerFromViewController:self usingDelegate:self];
}

- (BOOL) startCamerControllerFromViewController:(UIViewController *) controller usingDelegate:(id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
{
    // here, check the device is available  or not
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)|| (controller == nil)){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"当前设备不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [av show];
        return NO;
    }
    [self dismissPopupView];
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = delegate;
    cameraUI.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:cameraUI animated:YES completion:nil];
    
    return YES;
}
- (void) chooseHeadImageFromPhotoLibrary
{
    [self dismissPopupView];
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    ipc.allowsEditing = YES;
    ipc.delegate = self;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 52, 20, 44, 44)];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [ipc.view addSubview:btn];
//    ipc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

- ( void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) popupChangeNickNameView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(25, (bgView.bounds.size.height - 200) / 2, bgView.bounds.size.width - 50, 200)];
    view.backgroundColor = [AppConfig viewBackgroundColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, view.bounds.size.width, 70)];
    titleLabel.text = @"请输入昵称：";
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1]];
    [view addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), view.bounds.size.width, 1.5)];
    topLine.backgroundColor = titleLabel.textColor;
    [view addSubview:topLine];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), view.bounds.size.width, 60)];
    middleView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(25, 10, middleView.bounds.size.width - 50, 40)];
    textField.text = [UserSession sharedInstance].currentUserNickname;
    [textField setFont:[UIFont systemFontOfSize:16]];
    
    _nickNameTextField = textField;
    [middleView addSubview:textField];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1;
    
    [maskPath moveToPoint:CGPointMake(22, 44)];
    [maskPath addLineToPoint:CGPointMake(22, 48)];
    [maskPath addLineToPoint:CGPointMake(middleView.bounds.size.width - 22,48)];
    [maskPath addLineToPoint:CGPointMake(middleView.bounds.size.width - 22, 44)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = textField.bounds;
    maskLayer.fillColor = nil;
    maskLayer.strokeColor = titleLabel.textColor.CGColor;
    
    maskLayer.path = maskPath.CGPath;
    [middleView.layer addSublayer:maskLayer];
    [view addSubview:middleView];
    
    UIView *bottomHLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame) + 20, view.bounds.size.width, 1)];
    bottomHLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:bottomHLine];
    
    UIView *bottomVLine = [[UIView alloc]initWithFrame:CGRectMake(view.bounds.size.width / 2 - 0.5, CGRectGetMaxY(bottomHLine.frame), 1, view.bounds.size.height - CGRectGetMaxY(bottomHLine.frame))];
    bottomVLine.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:bottomVLine];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomHLine.frame), CGRectGetMinX(bottomVLine.frame), CGRectGetHeight(bottomVLine.frame))];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn addTarget:self action:@selector(dismissPopupView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bottomVLine.frame), CGRectGetMaxY(bottomHLine.frame), CGRectGetMinX(bottomVLine.frame), CGRectGetHeight(bottomVLine.frame))];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [doneBtn addTarget:self action:@selector(doneWithNickName) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    [bgView addSubview:view];
    _popupView = bgView;
    _inputView = view;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
    [textField becomeFirstResponder];
}

- (void) doneWithNickName
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@changeusername.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%lu",[UserSession sharedInstance].currentUserID],@"username":_nickNameTextField.text};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject [@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {
                [UserSession sharedInstance].currentUserNickname = _nickNameTextField.text;
                [self.tableView reloadData];
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"更新昵称成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"更新用户昵称失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
        
        [self dismissPopupView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
        [self dismissPopupView];
    }];
    if (![_webIndicator isAnimating]) {
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
    }
}

- (void) dismissPopupView
{
    [_popupView removeFromSuperview];
    _popupView = nil;
    _inputView = nil;
}

- (void) dismissKeyboard
{
    [_nickNameTextField resignFirstResponder];
}

- (void) uploadImageToServerWithImage:(UIImage *)image
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@up_file.php",BASE_URL];
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"myheadimage" fileName:[NSString stringWithFormat:@"%@_picname",[UserSession sharedInstance].currentUserTelNum] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"更改头像成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"更改头像失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [self dismissViewControllerAnimated:YES completion:nil];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    }];
    if (!_webIndicator.isAnimating) {
        [_webIndicator startAnimating];
    }
}
//MARK: UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    

    UIImage *originalImage, *editedImage, *imageToSave;

        
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }

    [self uploadImageToServerWithImage:imageToSave];
    
        
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:nil];
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
