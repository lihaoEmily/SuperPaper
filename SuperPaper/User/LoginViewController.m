//
//  LoginViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/20.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "LoginViewController.h"
#define TextFieldBorderColor [UIColor colorWithRed:233.0f/255 green:233.0f/255 blue:216.0/255 alpha:1].CGColor;
#define kSelColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *userLoginBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.userNameTextField.text = self.userTelNum;
    self.userNameTextField.layer.borderColor = TextFieldBorderColor;
    self.userNameTextField.layer.borderWidth = 1;
    self.pwdTextField.layer.borderWidth = 1;
    self.pwdTextField.layer.borderColor = TextFieldBorderColor;
    self.userLoginBtn.layer.masksToBounds = YES;
    self.userLoginBtn.layer.cornerRadius = 4;
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


- (IBAction)forgetPwd:(id)sender {
}
- (IBAction)login:(id)sender {
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
