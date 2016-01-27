//
//  FeedbackViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "FeedbackViewController.h"
#import "JSTextView.h"
@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet JSTextView *textView;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIImageView *FAQImageView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: 功能
- (IBAction)submit:(id)sender {
    
}
- (IBAction)faq:(id)sender {
    
}

//MARK: Helper
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(2, 5, 2, 5);
    self.textView.myPlaceholder = @"乐意聆听您对本客户端的任何意见和建议！";
    self.textView.myPlaceholderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textField.layer.borderWidth = 0.5;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.textField.bounds.size.height)];
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
