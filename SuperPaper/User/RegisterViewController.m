//
//  RegisterViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/20.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ServiceNoticesViewController.h"
#import "QRCodesController.h"
#import "AppConfig.h"

#define smsVerifyBaseURL @"http://sh2.ipyy.com/smsJson.aspx"

@interface RegisterViewController ()<UITextFieldDelegate>{
    UITextField *_editingTextField;
    BOOL _showPwd;
    BOOL _showConfirmPwd;
    NSString *_pwd;
    NSString *_confirmPwd;
    int _verifyCode;
    int _currentSMSTime;
    BOOL _agree;
    NSTimer *_timer;
    UIActivityIndicatorView *_webIndicator;
    CGFloat _originalTopCon;
}
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;

@property (weak, nonatomic) IBOutlet UITextField *telNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *SMSVerifyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *getSMSVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *showConfirmPwdBtn;
@property (weak, nonatomic) IBOutlet UITextField *qRCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *getQRCodeBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pwd = @"";
    _confirmPwd = @"";
    _originalTopCon = self.topCon.constant;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.telNumTextField.layer.borderColor = [AppConfig textFieldBgColor].CGColor;
    self.telNumTextField.layer.borderWidth = 1;
    self.SMSVerifyCodeTextField.layer.borderColor = [AppConfig textFieldBgColor].CGColor;
    self.SMSVerifyCodeTextField.layer.borderWidth = 1;
    self.getSMSVerifyCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.getSMSVerifyCodeBtn sizeToFit];
    self.showPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showPwdBtn sizeToFit];
    [self.view bringSubviewToFront:self.showPwdBtn];
    
    self.showConfirmPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showConfirmPwdBtn sizeToFit];
    self.getQRCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.getQRCodeBtn sizeToFit];
    //Hide QRCodeButton
    [self.getQRCodeBtn setHidden:YES];
    self.pwdTextField.layer.borderColor = [AppConfig textFieldBgColor].CGColor;
    self.pwdTextField.layer.borderWidth = 1;
    self.confirmPwdTextField.layer.borderColor = [AppConfig textFieldBgColor].CGColor;
    self.confirmPwdTextField.layer.borderWidth = 1;
    self.qRCodeTextField.layer.borderColor = [AppConfig textFieldBgColor].CGColor;
    self.qRCodeTextField.layer.borderWidth = 1;
    
    [self.serviceBtn setTitleColor:[AppConfig appNaviColor] forState:UIControlStateNormal];
    self.registerBtn.backgroundColor = [AppConfig appNaviColor];
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 4;
    

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);

    _webIndicator = indicator;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
    

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

//MARK:Helper
//键盘弹出
- (void)keyboardShow:(NSNotification *)noti
{
    
    NSDictionary *info  = noti.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGFloat moveDistance = keyboardFrame.origin.y - CGRectGetMaxY(_editingTextField.frame);
    if (moveDistance < 0) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]animations:^{
            self.topCon.constant += moveDistance;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    
    
}
//键盘收起
- (void)keyboardHide:(NSNotification *)noti
{
    CGFloat moveDistance = _originalTopCon - self.topCon.constant;
    if (moveDistance > 0) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]animations:^{
            self.topCon.constant += moveDistance;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    
}


- (BOOL) checkInput
{
    NSPredicate *telNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[3-8][0-9]{9}$"];
    if (![telNumPredicate evaluateWithObject:self.telNumTextField.text]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    
    if (![self.SMSVerifyCodeTextField.text isEqualToString:[NSString stringWithFormat:@"%d",_verifyCode]]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"短信验证码输入有误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码为6~16位字母和数字，请确认密码位数" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    if (![_pwd isEqualToString:_confirmPwd]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码输入不一致，请重新输入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    
    if (!_agree) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请同意《服务条款》" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    return YES;
}

- (void)retransmit:(NSTimer *)timer
{
    _currentSMSTime ++;
    if (_currentSMSTime < 60) {
        [self.getSMSVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新获取（%d）",60 - _currentSMSTime] forState:UIControlStateNormal];
        [self.getSMSVerifyCodeBtn sizeToFit];
        
    }else{
        [timer invalidate];
        _currentSMSTime = 0;
        [self.getSMSVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getSMSVerifyCodeBtn.userInteractionEnabled = YES;
        [self.getSMSVerifyCodeBtn sizeToFit];
    }
}

- (void)dismissKeyboard
{
    [_editingTextField resignFirstResponder];
}

//MARK: UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _editingTextField = textField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.pwdTextField) {
        _pwd = [_pwd stringByReplacingCharactersInRange:range withString:string];
        
        if (!_showPwd) {
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"•"];
            }else
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];

            return NO;
        }
        
    }else if (textField == self.confirmPwdTextField){
        _confirmPwd = [_confirmPwd stringByReplacingCharactersInRange:range withString:string];
        if (!_showConfirmPwd) {
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"•"];
            }else
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    return YES;
}
//MARK: IBAction
- (IBAction)getSMSCode:(id)sender {
    NSString *mobile = self.telNumTextField.text;
    NSPredicate *telNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[3-8][0-9]{9}$"];
    if (![telNumPredicate evaluateWithObject:mobile]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];

    }else{
        NSString *userid = @"conferplat";
        NSString *account = @"jksc227";
        NSString *password = @"jksc22766";
        int verifyCode = arc4random_uniform(9000) + 1000;
        NSString *content = [NSString stringWithFormat:@"您的验证码是%d,请不要把验证码泄露给其他人。如非本人操作，可不用理会！【超级论文】",verifyCode];
        NSDictionary *dic = @{@"action":@"send",@"userid":userid,@"account":account,@"password":password,@"mobile":mobile,@"content":[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"sendTime":@"",@"extno":@""};
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        [manager POST:smsVerifyBaseURL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *success = [responseObject valueForKey:@"returnstatus"];
            
            if (![success isEqualToString:@"Success"]) {//短信发送失败
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"短信发送失败！请重新发送" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                
            }else{//短信发送成功
                _verifyCode = verifyCode;
            }
            [_webIndicator stopAnimating];
            [_webIndicator removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [av show];
            [_webIndicator stopAnimating];
            [_webIndicator removeFromSuperview];
        }];
        if (![_webIndicator isAnimating]) {
            [_webIndicator startAnimating];
            [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
        }
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retransmit:) userInfo:nil repeats:YES];
        _timer = timer;
        _currentSMSTime = 0;
        _verifyCode = 0;
        [self.getSMSVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新获取（60）"] forState:UIControlStateNormal];
        [self.getSMSVerifyCodeBtn sizeToFit];
        self.getSMSVerifyCodeBtn.userInteractionEnabled = NO;
        
    }
    
}
- (IBAction)showOrHidePwd:(id)sender {
    _showPwd = !_showPwd;
    if (_showPwd) {
        [self.showPwdBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        
        self.pwdTextField.text = _pwd;
    }else{
        [self.showPwdBtn setTitle:@"显示" forState:UIControlStateNormal];
        NSString *encryptString = @"";
        for (int i = 0; i < _pwd.length; i ++) {
            encryptString = [encryptString stringByAppendingString:@"•"];
        }
        self.pwdTextField.text = encryptString;
        
    }
    [self.showPwdBtn sizeToFit];
}
- (IBAction)showOrHideConfirm:(id)sender {
    _showConfirmPwd = !_showConfirmPwd;
    if (_showConfirmPwd) {
        [self.showConfirmPwdBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        self.confirmPwdTextField.text = _confirmPwd;
        
    }else{
        [self.showConfirmPwdBtn setTitle:@"显示" forState:UIControlStateNormal];
        NSString *encryptString = @"";
        for (int i = 0; i < _confirmPwd.length; i ++) {
            encryptString = [encryptString stringByAppendingString:@"•"];
        }
        self.confirmPwdTextField.text = encryptString;
        
    }
    [self.showConfirmPwdBtn sizeToFit];
}
- (IBAction)scanQRCode:(id)sender {
    if ([QRCodesController isCameraAvailable]) {
        QRCodesController *vc = [[QRCodesController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        vc.ScanResult = ^(NSString *result,BOOL success){
            if (success) {
                
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"扫描二维码失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        };
    }else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"摄像头当前不可用！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
    
}
- (IBAction)agreeOrNot:(id)sender {
    _agree = !_agree;
    if (_agree) {
        [self.agreeBtn setImage:[UIImage imageNamed:@"复选框-2"] forState:UIControlStateNormal];
        
    }else
        [self.agreeBtn setImage:[UIImage imageNamed:@"复选框-1"] forState:UIControlStateNormal];
}
- (IBAction)serviceItemsChecking:(id)sender {
    ServiceNoticesViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"serviceitems"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)userRegister:(id)sender {
    if ([self checkInput]) {
        
        NSString *mobile = self.telNumTextField.text;
        NSString *pwd = _pwd;
        NSString *urlString = [NSString stringWithFormat:@"%@regist.php",BASE_URL];
        NSDictionary *dic = @{@"mobile":mobile,@"password":pwd};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *result = [responseObject valueForKey:@"result"];
            
            if (0 == result.integerValue) {//注册成功
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"注册成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
                LoginViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"login"];
                vc.userTelNum = mobile;
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if(1 == result.integerValue)//注册失败
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"注册失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else if (2 == result.integerValue){
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"这个手机号已经被注册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else if(3 == result.integerValue){
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"邀请码有误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            [_webIndicator stopAnimating];
            [_webIndicator removeFromSuperview];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            [_webIndicator stopAnimating];
            [_webIndicator removeFromSuperview];
        }];
        if (!_webIndicator.isAnimating) {
            [_webIndicator startAnimating];
            [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
        }
        
    }
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
