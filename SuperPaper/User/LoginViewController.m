//
//  LoginViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/20.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserViewController.h"
#import "UserSession.h"
#import "ForgetPwdViewController.h"
#define TextFieldBorderColor [UIColor colorWithRed:233.0f/255 green:233.0f/255 blue:216.0/255 alpha:1].CGColor;
#define kSelColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]
@interface LoginViewController ()<UITextFieldDelegate>
{
    BOOL _showPwd;
    UITextField *_editingTextField;
    NSString *_pwd;
    
}
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *userLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *quickRegisterBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pwd = @"";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.userNameTextField.text = self.userTelNum;
    self.userNameTextField.layer.borderColor = TextFieldBorderColor;
    self.userNameTextField.layer.borderWidth = 1;
    self.pwdTextField.layer.borderWidth = 1;
    self.pwdTextField.layer.borderColor = TextFieldBorderColor;
    self.showPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showPwdBtn sizeToFit];
    self.userLoginBtn.layer.masksToBounds = YES;
    self.userLoginBtn.layer.cornerRadius = 4;
    [self.quickRegisterBtn sizeToFit];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[self imageWithColor:kSelColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

//MARK:Helper
- (BOOL) checkInput
{
    if ([self.userNameTextField.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入用户名或手机号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码为6~16位字母和数字，请确认密码位数" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    return YES;
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

- (void)dismissKeyboard
{
    [_editingTextField resignFirstResponder];
}
//MARK:UITextFieldDelegate
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
    }
        
    
    return YES;
}

//MARK:IBActions
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

- (IBAction)forgetPwd:(id)sender {
    ForgetPwdViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"forgetPwd"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)login:(id)sender {
    if ([self checkInput]) {
        NSString *mobile = self.userNameTextField.text;
        NSString *pwd = _pwd;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *urlString = [NSString stringWithFormat:@"%@login.php",BASE_URL];
        NSDictionary *params = @{@"username":mobile,@"password":pwd};
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSNumber *result = [responseObject valueForKey:@"result"];
            
            if (0 == result.integerValue) {//注册成功
                NSInteger userId = [responseObject[@"id"] integerValue];
                NSString *userName;
                if ([responseObject[@"username"] isKindOfClass:[NSString class]]) {
                    userName = responseObject[@"username"];
                }else
                    userName = @"";
                NSString *mobile;
                if ([responseObject[@"mobile"]isKindOfClass:[NSString class]]) {
                    mobile = responseObject[@"mobile"];
                }else
                    mobile = @"";
                NSString *headImageName;
                if ([responseObject[@"headpic"]isKindOfClass:[NSString class]]) {
                    headImageName = responseObject[@"headpic"];
                }else
                    headImageName = @"";
                NSString *inviteCode = responseObject[@"myinvite_code"];
                [UserSession sharedInstance].currentUserID = userId;
                [UserSession sharedInstance].currentUserName = userName;
                [UserSession sharedInstance].currentUserTelNum = mobile;
                [UserSession sharedInstance].currentUserHeadImageName = headImageName;
                [UserSession sharedInstance].currentUserInviteCode = inviteCode;
                NSLog(@"邀请码%@",inviteCode);
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
                
            }else if(1 == result.integerValue)//登录失败
            {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"登录失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else if (2 == result.integerValue){//用户名或密码错误
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"用户名或密码错误" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            
        }];
        
        
    }
}
- (IBAction)quickRegister:(id)sender {
    RegisterViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:vc animated:YES];
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
