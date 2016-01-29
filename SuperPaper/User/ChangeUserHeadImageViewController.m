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
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *const HasNextIdentifier = @"hasnext";
static NSString *const ShowTextIdentifier = @"showtext";
@implementation ChangeUserHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    
    _webIndicator = indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        ChangeUserHeadImageHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleImageView.image = [UIImage imageNamed:@"usercell1"];
        cell.titleLabel.text = @"头像上传";
        cell.contentLabel.text = @"";
        return cell;
        
    }else if(1 == indexPath.row){
        ChangeUserHeadImageHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleImageView.image = [UIImage imageNamed:@"usercell2"];
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
- (void) popupChangeHeadImageView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    CGSize size = [UIScreen mainScreen].bounds.size;//屏幕尺寸
    UIButton *cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, size.height - 200, size.width - 50, 50)];
    [cameraBtn setTitle:@"拍 照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cameraBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cameraBtn setBackgroundColor:[UIColor whiteColor]];
    [cameraBtn addTarget:self action:@selector(chooseHeadImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cameraBtn];
    
    UIButton *photoLibraryBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, size.height - 135, size.width - 50, 50)];
    [photoLibraryBtn setTitle:@"从相册选择" forState:UIControlStateNormal];
    [photoLibraryBtn setTitleColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1] forState:UIControlStateNormal];
    [photoLibraryBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [photoLibraryBtn setBackgroundColor:[UIColor whiteColor]];
    [photoLibraryBtn addTarget:self action:@selector(chooseHeadImageFromPhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:photoLibraryBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, size.height - 70, size.width - 50, 50)];
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
    
}

- (void) chooseHeadImageFromPhotoLibrary
{
    [self dismissPopupView];
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
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
    [textField becomeFirstResponder];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
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
}

- (void) dismissKeyboard
{
    [_nickNameTextField resignFirstResponder];
}

//MARK: UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
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
