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
@interface RegisterViewController ()<UITextFieldDelegate>{
    UITextField *_editingTextField;
}

@property (weak, nonatomic) IBOutlet UITextField *telNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *SMSVerifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *qRCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
- (void)dismissKeyboard
{
    [_editingTextField resignFirstResponder];
}
- (IBAction)getSMSCode:(id)sender {
}
- (IBAction)showOrHidePwd:(id)sender {
}
- (IBAction)showOrHideConfirm:(id)sender {
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
