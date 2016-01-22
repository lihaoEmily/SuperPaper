//
//  RegisterViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/20.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "RegisterViewController.h"

#define TextFieldBorderColor [UIColor colorWithRed:233.0f/255 green:233.0f/255 blue:216.0/255 alpha:1].CGColor;
#define kSelColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]
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
}

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
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _agree = YES;
    _pwd = @"";
    _confirmPwd = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.telNumTextField.layer.borderColor = TextFieldBorderColor;
    self.telNumTextField.layer.borderWidth = 1;
    self.SMSVerifyCodeTextField.layer.borderColor = TextFieldBorderColor;
    self.SMSVerifyCodeTextField.layer.borderWidth = 1;
    self.pwdTextField.layer.borderColor = TextFieldBorderColor;
    self.pwdTextField.layer.borderWidth = 1;
    self.confirmPwdTextField.layer.borderColor = TextFieldBorderColor;
    self.confirmPwdTextField.layer.borderWidth = 1;
    self.qRCodeTextField.layer.borderColor = TextFieldBorderColor;
    self.qRCodeTextField.layer.borderWidth = 1;
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 4;
    

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[self imageWithColor:kSelColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK:Helper

- (BOOL) checkInput
{
    NSPredicate *telNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[3-8][0-9]{9}$"];
    if (![telNumPredicate evaluateWithObject:self.telNumTextField.text]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机号码" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
        [av show];
        return NO;
    }
    if (![self.SMSVerifyCodeTextField.text isEqualToString:[NSString stringWithFormat:@"%d",_verifyCode]]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"短信验证码输入有误" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
        [av show];
        return NO;
    }
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码为6~16位字母和数字，请确认密码位数" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
        [av show];
        return NO;
    }
    if (![_pwd isEqualToString:_confirmPwd]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码输入不一致，请重新输入" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
        [av show];
        return NO;
    }
    //TODO: 同意条款
    if (self.agreeBtn.imageView.image) {
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请同意《服务条款》" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
        [av show];
        return NO;
    }
    return YES;
}

- (void)retransmit:(NSTimer *)timer
{
    if (_currentSMSTime < 60) {
        [self.getSMSVerifyCodeBtn setTitle:[NSString stringWithFormat:@"重新获取（%d）",60 - _currentSMSTime] forState:UIControlStateNormal];
        _currentSMSTime ++;
    }else{
        [timer invalidate];
        _currentSMSTime = 0;
        [self.getSMSVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.getSMSVerifyCodeBtn.userInteractionEnabled = YES;
    }
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
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"•"];
            NSLog(@"代理方法%@,文本框%@哦雷",_pwd,textField.text);
            return NO;
        }
        
    }else if (textField == self.confirmPwdTextField){
        _confirmPwd = [_confirmPwd stringByReplacingCharactersInRange:range withString:string];
        if (!_showConfirmPwd) {
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"•"];
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
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入正确手机号码" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
        [av show];

    }else{
        NSString *userid = @"";
        NSString *account = @"";
        NSString *password = @"";
        int verifyCode = arc4random_uniform(10000) + 1000;
        NSString *content = [NSString stringWithFormat:@"您的验证码是%d，请不要把验证码泄露给他人。如非本人操作，可不用理会！【超级论文】",verifyCode];
        NSString *params = [NSString stringWithFormat:@"%@?action=send&userid=%@&account=%@&password=%@mobile=%@&content=%@&sendTime=&extno=",smsVerifyBaseURL,userid,account,password,mobile,content];
        NSURL *url = [NSURL URLWithString:params];
        NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];

        NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSError *newError;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&newError];
                if (newError) {
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:newError.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [av show];
                    });

                }else{
                    NSString *success = [dic valueForKey:@"returnstatus"];
                    if (![success isEqualToString:@"Success"]) {//短信发送失败
                        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"短信发送失败！请重新发送" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [av show];
                        });
                        
                    }else{//短信发送成功
                        _verifyCode = verifyCode;
                    }
                }
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"", nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [av show];
                });
            }

        }];
        [task resume];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retransmit:) userInfo:nil repeats:YES];
        [timer fire];
        _currentSMSTime = 0;
        self.getSMSVerifyCodeBtn.userInteractionEnabled = NO;
        
    }
    
}
- (IBAction)showOrHidePwd:(id)sender {
    NSLog(@"你好%@么",_pwd);
    _showPwd = !_showPwd;
    if (_showPwd) {
        [self.showPwdBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        self.pwdTextField.text = _pwd;
    }else{
        [self.showPwdBtn setTitle:@"显示" forState:UIControlStateNormal];
        self.pwdTextField.text = [_pwd stringByReplacingCharactersInRange:NSMakeRange(0, _pwd.length) withString:@"•"];
    }
}
- (IBAction)showOrHideConfirm:(id)sender {
    _showConfirmPwd = !_showConfirmPwd;
    if (_showConfirmPwd) {
        [self.showConfirmPwdBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        self.confirmPwdTextField.text = [_confirmPwd stringByReplacingCharactersInRange:NSMakeRange(0, _confirmPwd.length) withString:@"•"];
    }else{
        [self.showConfirmPwdBtn setTitle:@"显示" forState:UIControlStateNormal];
        self.confirmPwdTextField.text = _confirmPwd;
    }
}
- (IBAction)scanQRCode:(id)sender {
}
- (IBAction)agreeOrNot:(id)sender {
    
}
- (IBAction)serviceItemsChecking:(id)sender {
}
- (IBAction)userRegister:(id)sender {
    
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
