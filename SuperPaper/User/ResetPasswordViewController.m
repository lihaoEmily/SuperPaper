//
//  ResetPasswordViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/27.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "UserSession.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>{
    UIActivityIndicatorView *_webIndicator;
    UITextField *_editingTextField;
    BOOL _showOldPwd;
    BOOL _showNewPwd;
    BOOL _showConfirmPwd;
    NSString *_oldPwd;
    NSString *_newPwd;
    NSString *_confirmPwd;
}
@property (weak, nonatomic) IBOutlet UIButton *showOldPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *showNewPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *showConfirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;


@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _oldPwd = @"";
    _newPwd = @"";
    _confirmPwd = @"";
    [self.view bringSubviewToFront:self.showOldPwdBtn];
    [self.view bringSubviewToFront:self.showNewPwdBtn];
    [self.view bringSubviewToFront:self.showConfirmBtn];
    self.showOldPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showOldPwdBtn sizeToFit];
    self.showNewPwdBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showNewPwdBtn sizeToFit];
    self.showConfirmBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 18);
    [self.showConfirmBtn sizeToFit];
    [self.submitBtn setBackgroundColor:[AppConfig appNaviColor]];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 4;
    self.oldPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.oldPwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)];
    self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.pwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)];
    self.confirmPwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPwdTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Helper
- (void)dismissKeyboard
{
    [_editingTextField resignFirstResponder];
}
- (BOOL)checkInput
{
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码为6~16位字母和数字，请确认密码位数" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    if (![_confirmPwd isEqualToString:_newPwd]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"密码输入不一致，请重新输入" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }
    return YES;
}
//MARK:UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _editingTextField = textField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.oldPwdTextField) {
        _oldPwd = [_oldPwd stringByReplacingCharactersInRange:range withString:string];
        
        if (!_showOldPwd) {
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"•"];
            }else
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
        }
    }
    
    if (textField == self.pwdTextField) {
        _newPwd = [_newPwd stringByReplacingCharactersInRange:range withString:string];
        
        if (!_showNewPwd) {
            if (![string isEqualToString:@""]) {
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@"•"];
            }else
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
        }
    }
    
    if (textField == self.confirmPwdTextField) {
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

- (IBAction)showOldPwdOrNot:(id)sender {
    _showOldPwd = !_showOldPwd;
    if (_showOldPwd) {
        [self.showOldPwdBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        
        self.oldPwdTextField.text = _oldPwd;
    }else{
        [self.showOldPwdBtn setTitle:@"显示" forState:UIControlStateNormal];
        NSString *encryptString = @"";
        for (int i = 0; i < _oldPwd.length; i ++) {
            encryptString = [encryptString stringByAppendingString:@"•"];
        }
        self.oldPwdTextField.text = encryptString;
        
    }
    [self.showOldPwdBtn sizeToFit];
}
- (IBAction)showNewPwdOrNot:(id)sender {
    _showNewPwd = !_showNewPwd;
    if (_showNewPwd) {
        [self.showNewPwdBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        
        self.pwdTextField.text = _newPwd;
    }else{
        [self.showNewPwdBtn setTitle:@"显示" forState:UIControlStateNormal];
        NSString *encryptString = @"";
        for (int i = 0; i < _newPwd.length; i ++) {
            encryptString = [encryptString stringByAppendingString:@"•"];
        }
        self.pwdTextField.text = encryptString;
        
    }
    [self.showNewPwdBtn sizeToFit];
}
- (IBAction)showConfirmOrNot:(id)sender {
    _showConfirmPwd = !_showConfirmPwd;
    if (_showConfirmPwd) {
        [self.showConfirmBtn setTitle:@"隐藏" forState:UIControlStateNormal];
        
        self.confirmPwdTextField.text = _confirmPwd;
    }else{
        [self.showConfirmBtn setTitle:@"显示" forState:UIControlStateNormal];
        NSString *encryptString = @"";
        for (int i = 0; i < _confirmPwd.length; i ++) {
            encryptString = [encryptString stringByAppendingString:@"•"];
        }
        self.confirmPwdTextField.text = encryptString;
        
    }
    [self.showConfirmBtn sizeToFit];
}
- (IBAction)submit:(id)sender {
    if ([self checkInput]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *urlString = [NSString stringWithFormat:@"%@changepassword.php",BASE_URL];

        NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%lu",(long)[UserSession sharedInstance].currentUserID],@"old_pw":_oldPwd,@"new_pw":_newPwd};
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                NSNumber *result = responseObject[@"result"];
                if (0 == result.integerValue) {
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"修改密码成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                    [self.navigationController popViewControllerAnimated:YES];
                }else if(1 == result.integerValue){
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"修改密码失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }else{
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"原密码错误！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"修改密码失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
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
