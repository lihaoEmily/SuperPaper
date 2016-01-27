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

@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_popupView;
    UserGen _currentGen;
    UIButton *_manBtn;
    UIButton *_womanBtn;
    UITextField *_currentTextField;
    UIDatePicker *_datePicker;
    UIButton *_teacherBtn;
    UIButton *_studentBtn;
    UserRole _currentRole;
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
            
            if ([responseObject[@"sex"] respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                self.gender = 0 == [responseObject[@"sex"]integerValue]?@"男":@"女";
                
            }else{
                
                self.gender = @"";
            }
            if ([responseObject[@"age"] respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                self.age = [responseObject[@"age"]integerValue];
            }else
                self.age = 0;
            
            if ([responseObject[@"jobtitle"] respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                self.career = 0 == [responseObject[@"jobtitle"]integerValue]?@"老师":@"学生";
            }else
                self.career = @"";
            
            if ([responseObject[@"school"]isKindOfClass:[NSString class]]) {
                self.college = responseObject[@"school"];
            }else
                self.college = @"";
            
            [self.tableView reloadData];
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取个人信息失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }];
}


//MARK: Helper
- (void) dismissKeyboard
{
    [_currentTextField resignFirstResponder];
}
- (void) chooseMan
{
    if (_currentGen != kUserGen_Man) {
        _currentGen = kUserGen_Man;
        [_manBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
        [_womanBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    }
}

- (void) chooseWoman
{
    if (_currentGen != kUserGen_Woman) {
        _currentGen = kUserGen_Woman;
        [_manBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
        [_womanBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
}

- (void) chooseTeacher
{
    if (_currentRole != kUserRoleTeacher) {
        _currentRole = kUserRoleTeacher;
        [_teacherBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
        [_studentBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    }
}

- (void) chooseStudent
{
    if (_currentRole != kUserRoleStudent) {
        _currentRole = kUserRoleStudent;
        [_teacherBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
        [_studentBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
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
    [textField becomeFirstResponder];
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
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
}

- (void) popupChangeGenderView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(25, (bgView.bounds.size.height - 200) / 2, bgView.bounds.size.width - 50, 200)];
    view.backgroundColor = [AppConfig viewBackgroundColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, view.bounds.size.width, 70)];
    titleLabel.text = @"请选择性别：";
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1]];
    [view addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), view.bounds.size.width, 1.5)];
    topLine.backgroundColor = titleLabel.textColor;
    [view addSubview:topLine];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), view.bounds.size.width, 90)];
    middleView.backgroundColor = [UIColor whiteColor];
    UIButton *manBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 10, 100, 35)];
    manBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [manBtn setTitle:@"男" forState:UIControlStateNormal];
    [manBtn addTarget:self action:@selector(chooseMan) forControlEvents:UIControlEventTouchUpInside];
    _manBtn = manBtn;
    [middleView addSubview:manBtn];
    
    UIButton *womanBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(manBtn.frame), 100, 35)];
    womanBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [womanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [womanBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [womanBtn addTarget:self action:@selector(chooseWoman) forControlEvents:UIControlEventTouchUpInside];
    _womanBtn = womanBtn;
    [middleView addSubview:womanBtn];
    if (kUserGen_Man == _currentGen) {
        [manBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
        [womanBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    }else{
        [manBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
        [womanBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
    [view addSubview:middleView];
    
    UIView *bottomHLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame), view.bounds.size.width, 1)];
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
    [doneBtn addTarget:self action:@selector(doneWithGender) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    [bgView addSubview:view];
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPopupView)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
}

- (void) popupChangeAgeView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(25, (bgView.bounds.size.height - 200) / 2, bgView.bounds.size.width - 50, 200)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy:MM:dd";
    datePicker.date = [dateFormatter dateFromString:@"1995:06:06"];
    _datePicker = datePicker;
    [bgView addSubview:datePicker];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(datePicker.frame), bgView.bounds.size.width - 50, 40)];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:[UIColor whiteColor]];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    doneBtn.layer.borderWidth = 1;
    doneBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [doneBtn addTarget:self action:@selector(doneWithAge) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:doneBtn];
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPopupView)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
    
}

-(void) popupChangeCareerView
{
    UIView *bgView = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    bgView.layer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7].CGColor;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(25, (bgView.bounds.size.height - 200) / 2, bgView.bounds.size.width - 50, 200)];
    view.backgroundColor = [AppConfig viewBackgroundColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, view.bounds.size.width, 70)];
    titleLabel.text = @"请选择职业：";
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:14.0f/255 green:168.0f/255 blue:221.0f/255 alpha:1]];
    [view addSubview:titleLabel];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), view.bounds.size.width, 1.5)];
    topLine.backgroundColor = titleLabel.textColor;
    [view addSubview:topLine];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), view.bounds.size.width, 90)];
    middleView.backgroundColor = [UIColor whiteColor];
    UIButton *teacherBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 10, 100, 35)];
    [teacherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    teacherBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [teacherBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [teacherBtn setTitle:@"老师" forState:UIControlStateNormal];
    [teacherBtn addTarget:self action:@selector(chooseTeacher) forControlEvents:UIControlEventTouchUpInside];
    _teacherBtn = teacherBtn;
    [middleView addSubview:teacherBtn];
    
    UIButton *studentBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(teacherBtn.frame), 100, 35)];
    studentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;;
    [studentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [studentBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [studentBtn setTitle:@"学生" forState:UIControlStateNormal];
    [studentBtn addTarget:self action:@selector(chooseStudent) forControlEvents:UIControlEventTouchUpInside];
    _studentBtn = studentBtn;
    [middleView addSubview:studentBtn];
    if (kUserRoleTeacher == _currentRole) {
        [teacherBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
        [studentBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    }else{
        [teacherBtn setImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
        [studentBtn setImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    }
    [view addSubview:middleView];
    
    UIView *bottomHLine = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame), view.bounds.size.width, 1)];
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
    [doneBtn addTarget:self action:@selector(doneWithCareer) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:doneBtn];
    [bgView addSubview:view];
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissPopupView)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
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
    [textField becomeFirstResponder];
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
    _popupView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [bgView addGestureRecognizer:tap];
    [[[UIApplication sharedApplication]keyWindow]addSubview:_popupView];
}
- (void) dismissPopupView
{
    [_popupView removeFromSuperview];
    _popupView = nil;
    _womanBtn = nil;
    _manBtn = nil;
    _studentBtn = nil;
    _teacherBtn = nil;
    _datePicker = nil;
}
- (void) doneWithName
{
    self.name = _currentTextField.text;
    [self.tableView reloadData];
    [self dismissPopupView];
}

- (void) doneWithGender
{
    self.gender = _currentGen == kUserGen_Man?@"男":@"女";
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
    
    return nowYear.integerValue - year.integerValue;
}
- (void) doneWithAge
{
    self.age = [self calculateAgeWithBornDate:_datePicker.date];
    [self.tableView reloadData];
    [self dismissPopupView];
}

- (void) doneWithCareer
{
    self.career = _currentRole == kUserRoleTeacher?@"老师":@"学生";
    [self.tableView reloadData];
    [self dismissPopupView];
}

- (void) doneWithCollege
{
    self.college = _currentTextField.text;
    [self.tableView reloadData];
    [self dismissPopupView];
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
            [UserSession sharedInstance].currentRole = [self.career isEqualToString:@"老师"]?kUserRoleTeacher:kUserRoleStudent;
            [UserSession sharedInstance].currentUserCollege = self.college;
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"个人信息修改成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取个人信息失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }];

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
        cell.titleLabel.text = @"手机号码";
        cell.telNoLabel.text = self.telNo;
        return cell;
    }else if(6 == indexPath.row){
        ProfileSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubmitIdentifier];
        cell.superController = self;
        return cell;
    }
    PersonalInfoHasSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
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
            cell.detailsLabel.text = 0 == self.age?@"":[NSString stringWithFormat:@"%lu",self.age];
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
