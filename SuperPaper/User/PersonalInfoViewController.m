//
//  PersonalInfoViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoHasSelectionTableViewCell.h"
#import "PersonalInfoTableViewCell.h"
#import "ProfileSubmitTableViewCell.h"
#import "AppConfig.h"
#import "UserSession.h"

@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIView *_popupView;
    UserGen _currentGen;
    UITextField *_currentTextField;
    UIDatePicker *_datePicker;
    UserRole _currentRole;
    UIView *_inputView;
    UIActivityIndicatorView *_webIndicator;
    CGRect _originalFrame;
}
@property (nonatomic, copy) NSString *telNo;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *career;
@property (nonatomic, copy) NSString *college;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *const TelIdentifier = @"Tel";
static NSString *const HasNextIdentifier = @"HasNext";
static NSString *const SubmitIdentifier = @"submit";
@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.telNo = [UserSession sharedInstance].currentUserTelNum;
    self.name = [UserSession sharedInstance].currentUserName;
    self.gender = kUserGen_Man == [UserSession sharedInstance].currentUserGen?@"男":@"女";
    self.age = [UserSession sharedInstance].currentUserAge;
    self.career = kUserRoleTeacher == [UserSession sharedInstance].currentRole?@"老师":@"学生";
    self.college = [UserSession sharedInstance].currentUserCollege;
    _currentGen = [UserSession sharedInstance].currentUserGen;
    _currentRole = [UserSession sharedInstance].currentRole;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@getuserinfo.php",BASE_URL];
    NSDictionary *params = @{@"uid":@([UserSession sharedInstance].currentUserID)};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//成功
            self.name = responseObject[@"realname"]?responseObject[@"realname"]:nil;
            [UserSession sharedInstance].currentUserName = self.name;
            if ([responseObject[@"sex"] respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                self.gender = 0 == [responseObject[@"sex"]integerValue]?@"男":@"女";
                
            }else{
                
                self.gender = @"男";
            }
            [UserSession sharedInstance].currentUserGen = [responseObject[@"sex"]integerValue];
            if ([responseObject[@"age"] respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                self.age = [responseObject[@"age"]integerValue];
            }else
                self.age = 0;
            [UserSession sharedInstance].currentUserAge = self.age;
            if ([responseObject[@"jobtitle"] respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                self.career = 0 == [responseObject[@"jobtitle"]integerValue]?@"老师":@"学生";
            }else
                self.career = @"老师";
            
            if ([responseObject[@"school"]isKindOfClass:[NSString class]]) {
                self.college = responseObject[@"school"];
            }else
                self.college = @"";
            [UserSession sharedInstance].currentUserCollege = self.college;
            [self.tableView reloadData];
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取个人信息失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

//MARK: Helper
//键盘弹出
- (void)keyboardShow:(NSNotification *)noti
{
    
    _originalFrame = _inputView.frame;
    
    NSDictionary *info  = noti.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [_popupView convertRect:rawFrame fromView:nil];
    CGFloat moveDistance = keyboardFrame.origin.y - CGRectGetMaxY(_originalFrame);
    if (CGRectGetMaxY(_originalFrame) > keyboardFrame.origin.y) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]animations:^{
            _inputView.frame =  CGRectOffset(_inputView.frame, 0, moveDistance);
        } completion:nil];
    }
    
    
}
//键盘收起
- (void)keyboardHide:(NSNotification *)noti
{
    
    if (_originalFrame.origin.y > _inputView.frame.origin.y) {
        [UIView animateWithDuration:[noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[noti.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]animations:^{
            _inputView.frame =  CGRectOffset(_inputView.frame, 0, _originalFrame.origin.y - _inputView.frame.origin.y);
        } completion:nil];
    }
    
}


- (void) dismissKeyboard
{
    [_currentTextField resignFirstResponder];
}
- (void) chooseMan
{
    _currentGen = kUserGen_Man;
    self.gender = @"男";
    [self.tableView reloadData];
}

- (void) chooseWoman
{
    _currentGen = kUserGen_Woman;
    self.gender = @"女";
    [self.tableView reloadData];
}

- (void) chooseTeacher
{
    _currentRole = kUserRoleTeacher;
    self.career = @"老师";
    [self.tableView reloadData];
    
}

- (void) chooseStudent
{
    
    _currentRole = kUserRoleStudent;
    self.career = @"学生";
    [self.tableView reloadData];
}

- (void) popupChangeNameView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(25, (bgView.bounds.size.height - 200) / 2, bgView.bounds.size.width - 50, 200)];
    view.backgroundColor = [AppConfig viewBackgroundColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, view.bounds.size.width, 70)];
    titleLabel.text = @"请输入您的真实姓名：";
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1]];
    [view addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), view.bounds.size.width, 1.5)];
    topLine.backgroundColor = titleLabel.textColor;
    [view addSubview:topLine];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), view.bounds.size.width, 60)];
    middleView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(25, 10, middleView.bounds.size.width - 50, 40)];
    textField.text = [UserSession sharedInstance].currentUserName;
    [textField setFont:[UIFont systemFontOfSize:16]];

    _currentTextField = textField;
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
    [doneBtn addTarget:self action:@selector(doneWithName) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    [bgView addSubview:view];
    _inputView = view;
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
    [textField becomeFirstResponder];
}

//FIXME: UIAlertController 在iOS 8以后使用，如果适配Pad需要调整，否则会引起崩溃的现象
- (void) popupChangeGenderView
{
    if ([[UIDevice currentDevice]systemVersion].floatValue < 8.0) {
        UIActionSheet *av = [[UIActionSheet alloc]initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        av.tag = 0;
        [av showInView:self.view];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *chooseMan = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseMan];
        }];
        UIAlertAction *chooseWoman = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseWoman];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:chooseMan];
        [alertController addAction:chooseWoman];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void) popupChangeAgeView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setBackgroundColor:kColor(240, 240, 240)];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *datePickerLeadingCon = [NSLayoutConstraint constraintWithItem:datePicker attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *datePickerBottomCon = [NSLayoutConstraint constraintWithItem:datePicker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *datePickerTrailingCon = [NSLayoutConstraint constraintWithItem:datePicker attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:bgView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *datePickerHeightCon = [NSLayoutConstraint constraintWithItem:datePicker attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy:MM:dd";
    datePicker.date = [dateFormatter dateFromString:@"1995:06:06"];
    _datePicker = datePicker;
    [bgView addSubview:datePicker];
    [bgView addConstraints:@[datePickerLeadingCon,datePickerBottomCon,datePickerHeightCon,datePickerTrailingCon]];
    
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doneWithAge)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
    
}

//FIXME: UIAlertController 在iOS 8以后使用，如果适配Pad需要调整，否则会引起崩溃的现象
-(void) popupChangeCareerView
{
    if ([[UIDevice currentDevice]systemVersion].floatValue < 8.0) {
        UIActionSheet *av = [[UIActionSheet alloc]initWithTitle:@"请选择职业" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"老师",@"学生", nil];
        av.tag = 1;
        [av showInView:self.view];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择职业" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *chooseTeacher = [UIAlertAction actionWithTitle:@"老师" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self chooseTeacher];
        }];
        UIAlertAction *chooseStudent = [UIAlertAction actionWithTitle:@"学生" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self chooseStudent];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:chooseTeacher];
        [alertController addAction:chooseStudent];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (void) popupChangeCollegeView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(25, (bgView.bounds.size.height - 200) / 2, bgView.bounds.size.width - 50, 200)];
    view.backgroundColor = [AppConfig viewBackgroundColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, view.bounds.size.width, 70)];
    titleLabel.text = @"请输入您的学校名称：";
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1]];
    [view addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), view.bounds.size.width, 1.5)];
    topLine.backgroundColor = titleLabel.textColor;
    [view addSubview:topLine];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), view.bounds.size.width, 60)];
    middleView.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(25, 10, middleView.bounds.size.width - 50, 40)];
    _currentTextField = textField;
    textField.text = [UserSession sharedInstance].currentUserCollege;
    [textField setFont:[UIFont systemFontOfSize:16]];
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
    [doneBtn addTarget:self action:@selector(doneWithCollege) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    [bgView addSubview:view];
    _inputView = view;
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
    [textField becomeFirstResponder];
}
- (void) dismissPopupView
{
    [_popupView removeFromSuperview];
    _popupView = nil;
    _datePicker = nil;
    _inputView = nil;
}
- (void) doneWithName
{
    self.name = _currentTextField.text;
    [self.tableView reloadData];
    [self dismissPopupView];
}


- (NSInteger) calculateAgeWithBornDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy:MM:dd";
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *year = [dateStr componentsSeparatedByString:@":"][0];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    NSString *nowYear = [nowStr componentsSeparatedByString:@":"][0];
    
    NSInteger age = nowYear.integerValue - year.integerValue;
    if (age <= 0) {
        return 0;
    } else {
        return age;
    }
}
- (void) doneWithAge
{
    self.age = [self calculateAgeWithBornDate:_datePicker.date];
    [self.tableView reloadData];
    [self dismissPopupView];
}

- (void) doneWithCollege
{
    self.college = _currentTextField.text;
    [self.tableView reloadData];
    [self dismissPopupView];
}

//MARK: AlertView Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == actionSheet.tag) {
        if (0 == buttonIndex) {
            [self chooseMan];
        }else if(1 == buttonIndex)
            [self chooseWoman];
    }else{
        if (0 == buttonIndex) {
            [self chooseTeacher];
        }else if(1 == buttonIndex)
            [self chooseStudent];
    }
}
//MARK: 功能
- (void) submit
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@updateuserinfo.php",BASE_URL];
    NSDictionary *params = @{@"uid":@([UserSession sharedInstance].currentUserID),@"realname":self.name,@"sex":[self.gender isEqualToString:@"男"]?@(0):@(1),@"age":@(self.age),@"jobtitle":[self.career isEqualToString:@"老师"]?@(0):@(1),@"school":self.college};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//成功
            
            [UserSession sharedInstance].currentUserName = self.name;
            [UserSession sharedInstance].currentUserGen = [self.gender isEqualToString:@"男"]?kUserGen_Man:kUserGen_Woman;
            [UserSession sharedInstance].currentUserAge = self.age;
            [UserSession sharedInstance].currentUserCollege = self.college;
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"个人信息修改成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取个人信息失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
//MARK:TableViewDataSource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (6 == indexPath.row) {
        return 80;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        PersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TelIdentifier];
//        cell.titleLabel.font = [UIFont systemFontOfSize:18];
        cell.titleLabel.text = @"手机号码";
        cell.telNoLabel.text = self.telNo;
        return cell;
    }else if(6 == indexPath.row){
        ProfileSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitIdentifier];
        cell.superController = self;
        return cell;
    }
    PersonalInfoHasSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
    cell.titleLabel.font = [UIFont systemFontOfSize:18];
    switch (indexPath.row) {
        case 1:
        {
            cell.titleLabel.text = @"真实姓名";
            cell.detailsLabel.text = self.name;
            
        }
            break;
        case 2:{
            cell.titleLabel.text = @"性   别";
            cell.detailsLabel.text = self.gender;
        }
            break;
        case 3:{
            cell.titleLabel.text = @"年   龄";
            cell.detailsLabel.text = 0 == self.age?@"":[NSString stringWithFormat:@"%lu",(long)self.age];
        }
            break;
        case 4:{
            cell.titleLabel.text = @"职业选择";
            cell.detailsLabel.text = self.career;
        }
            break;
        case 5:{
            cell.titleLabel.text = @"学校名称";
            cell.detailsLabel.text = self.college;
        }
            break;
        default:
            break;
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        switch (indexPath.row) {
            case 1://真实姓名
            {
                [self popupChangeNameView];
            }
                break;
            case 2://性别
            {
                [self popupChangeGenderView];
            }
                break;
            case 3://年龄
            {
                [self popupChangeAgeView];
            }
                break;
            case 4://职业选择
            {
                [self popupChangeCareerView];
            }
                break;
            case 5://学校名称
            {
                [self popupChangeCollegeView];
            }
                break;
            default:
                break;
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
