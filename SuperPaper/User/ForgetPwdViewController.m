//
//  ForgetPwdViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/22.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "AppConfig.h"
#import "UserSession.h"

#define TextFieldBorderColor [UIColor colorWithRed:233.0f/255 green:233.0f/255 blue:216.0/255 alpha:1].CGColor;
#define smsVerifyBaseURL @"http://sh2.ipyy.com/smsJson.aspx"
@interface ForgetPwdViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    NSTimer *_timer;
    int _verifyCode;
    NSString *_pwd;
    NSString *_confirmPwd;
    UITextField *_editingTextField;
    BOOL _showPwd;
    BOOL _showConfirmPwd;
    int _currentSMSTime;
    UIActivityIndicatorView *_webIndicator;
    CGFloat _originalTopCon;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (weak, nonatomic) IBOutlet UITextField *telNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsVerifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *showConfirmPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetPwdBtn;
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pwd = @"";
    _confirmPwd = @"";
    _originalTopCon = self.topCon.constant;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.telNumTextField.layer.borderColor = TextFieldBorderColor;
    self.telNumTextField.layer.borderWidth = 1;
    self.smsVerifyCodeTextField.layer.borderColor = TextFieldBorderColor;
    self.smsVerifyCodeTextField.layer.borderWidth = 1;
    self.getVerifyCodeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16);
    [self.getVerifyCodeBtn sizeToFit];
    self.showPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showPwdBtn sizeToFit];
    self.showConfirmPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showConfirmPwdBtn sizeToFit];
    self.pwdTextField.layer.borderColor = TextFieldBorderColor;
    self.pwdTextField.layer.borderWidth = 1;
    self.confirmPwdTextField.layer.borderColor = TextFieldBorderColor;
    self.confirmPwdTextField.layer.borderWidth = 1;

    
    self.resetPwdBtn.layer.masksToBounds = YES;
    self.resetPwdBtn.layer.cornerRadius = 4;
    
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

    if (![self.smsVerifyCodeTextField.text isEqualToString:[NSString stringWithFormat:@"%d",_verifyCode]]) {
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
    
    return YES;
}

- (void)popViewControler
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dismissKeyboard
{
    [_editingTextField resignFirstResponder];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)retransmit:(NSTimer *)timer
{
    _currentSMSTime ++;
    if (_currentSMSTime < 60) {
        [self.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新获取（%d）",60 - _currentSMSTime] forState:UIControlStateNormal];
        [self.getVerifyCodeBtn sizeToFit];
        
    }else{
        [timer invalidate];
        _currentSMSTime = 0;
        [self.getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getVerifyCodeBtn.userInteractionEnabled = YES;
        [self.getVerifyCodeBtn sizeToFit];
    }
}

//MARK:UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == alertView.tag) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入正确手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        
    }else{
        NSString *userid = @"conferplat";
        NSString *account = @"jksc227";
        NSString *password = @"jksc22766";
        int verifyCode = arc4random_uniform(9000) + 1000;
        NSString *content = [NSString stringWithFormat:@"您的验证码是%d,请不要把验证码泄露给其他人。如非本人操作，可不用理会！【超级论文】",verifyCode];
        
        NSString *params = [[NSString stringWithFormat:@"action=send&userid=%@&account=%@&password=%@&mobile=%@&content=%@&sendTime=&extno=",userid,account,password,mobile,content]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
        NSURL *url = [NSURL URLWithString:smsVerifyBaseURL];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [_webIndicator stopAnimating];
            [_webIndicator removeFromSuperview];
            if (data) {
                NSError *newError;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&newError];
                if (newError) {//json解析出错
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:newError.localizedDescription message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [av show];
                    });
                    
                }else{
                    NSString *success = [dic valueForKey:@"returnstatus"];
                    
                    if (![success isEqualToString:@"Success"]) {//短信发送失败
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"短信发送失败！请重新发送" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [av show];
                        });
                        
                    }else{//短信发送成功
                        _verifyCode = verifyCode;
                    }
                }
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [av show];
                });
            }
            
        }];
        [task resume];
        if (!_webIndicator.isAnimating) {
            [_webIndicator startAnimating];
        }
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retransmit:) userInfo:nil repeats:YES];
        _timer = timer;
        _currentSMSTime = 0;
        _verifyCode = 0;
        [self.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新获取（60）"] forState:UIControlStateNormal];
        [self.getVerifyCodeBtn sizeToFit];
        self.getVerifyCodeBtn.userInteractionEnabled = NO;
        
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
- (IBAction)resetPwd:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@findpassword.php",BASE_URL];
    NSDictionary *params = @{@"userinfo":self.telNumTextField.text,@"password":_pwd};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"登录密码修改成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            av.tag = 1;
            [av show];
            
            
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"登录密码修改失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    }
    [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
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
