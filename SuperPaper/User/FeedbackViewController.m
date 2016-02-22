//
//  FeedbackViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FAQViewController.h"
#import "JSTextView.h"
#import "UserSession.h"
@interface FeedbackViewController (){
    UIActivityIndicatorView *_webIndicator;
    CGFloat _originalTopCon;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCon;
@property (weak, nonatomic) IBOutlet JSTextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _originalTopCon = self.topCon.constant;
    [self setupUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
//MARK: 功能
- (IBAction)submit:(id)sender {
    if ([self checkInput]) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *urlString = [NSString stringWithFormat:@"%@submitfeedback.php",BASE_URL];
        NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%ld",(long)[UserSession sharedInstance].currentUserID],@"content":self.textView.text,@"mobile":self.textField.text};
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                NSNumber *result = responseObject[@"result"];
                if (0 == result.integerValue) {
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提交反馈成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提交反馈失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                    
                }
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
- (IBAction)faq:(id)sender {
    
    FAQViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"faq"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)dismissKeyboard:(id)sender {
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

//MARK: Helper
- (BOOL)checkInput
{
    if ([self.textView.text isEqualToString:@""]||!self.textView.text) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入反馈内容！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }else if([self.textField.text isEqualToString:@""]||!self.textField.text){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入您的联系方式！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        return NO;
    }else{
        NSPredicate *telNumPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[3-8][0-9]{9}$"];
        if (![telNumPredicate evaluateWithObject:self.textField.text]) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机号码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            return NO;
        }
    }
    return YES;
}
//键盘弹出
- (void)keyboardShow:(NSNotification *)noti
{
    
    NSDictionary *info  = noti.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    CGFloat moveDistance = keyboardFrame.origin.y - CGRectGetMaxY(self.textField.frame);
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


- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(2, 5, 2, 5);
    self.textView.myPlaceholder = @"乐意聆听您对本客户端的任何意见和建议！";
    self.textView.myPlaceholderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    self.submitBtn.backgroundColor = [AppConfig appNaviColor];
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.textField.bounds.size.height)];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
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
