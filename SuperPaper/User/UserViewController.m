//
//  UserViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserViewController.h"
#import "MainViewController.h"
#import "UserSession.h"
#import "UIImageView+WebCache.h"
#import "UserTableViewCell.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ChangeUserHeadImageViewController.h"
#import "AboutUsViewController.h"
#import <CoreTelephony/CTCall.h>
typedef enum{
    
    UserHeaderTypeLogin,
    UserHeaderTypeRegister,
    UserHeaderTypeCamera
    
}UserHeaderType;


@interface UserViewController () <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    NSArray *_titles;
    BOOL _hasCurrentUser;
    UILabel *_userTelLabel;
    UIButton *_userHeaderImageBtn;
    NSString *_unReadMessageCountStr;
    NSString *_papersCountStr;
    NSString *_aboutMeStr;
    NSString *_service_telStr;
}

@property (weak, nonatomic) IBOutlet UITableView *backTableView;
@property (nonatomic ,strong) UIView *loginHeaderView;
@property (nonatomic ,strong) UIView *userHeaderView;

@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *registerButton;


@end

static NSString *cellIdentifier = @"UserTableViewCell";
@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"我的消息",
                @"个人信息",
                @"我的账户",
                @"我的邀请",
                @"职业选择",
                @"我的论文",
                @"关于我们",
                @"意见反馈",
                @"客服电话"
                ];

    [self setupLoginHeaderView];
    [self setupUserHeaderView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //TODO: 登陆成功返回刷新页面
    if ([UserSession sharedInstance].currentUserID != 0) {//用户已经登录
        if ([UserSession sharedInstance].currentUserHeadImageName && ![[UserSession sharedInstance].currentUserHeadImageName isEqualToString:@""]) {
            NSLog(@"用户已登录且有头像！%@",[UserSession sharedInstance].currentUserHeadImageName);
            [_userHeaderImageBtn.imageView sd_setImageWithURL:[NSURL URLWithString:[UserSession sharedInstance].currentUserHeadImageName] placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
        }else
            [_userHeaderImageBtn setBackgroundImage:[UIImage imageNamed:@"user_normalIcon"] forState:UIControlStateNormal];
        _userTelLabel.text = [UserSession sharedInstance].currentUserTelNum;
        
        NSString *urlString = [NSString stringWithFormat:@"%@getmeinfo.php",BASE_URL];
        NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                NSNumber *result = responseObject[@"result"];
                if (0 == result.integerValue) {//获取我的主页信息接口成功
                    _unReadMessageCountStr = responseObject[@"notice_num"];
                    if ([_unReadMessageCountStr isEqualToString:@"0"]) {
                        _unReadMessageCountStr = @"";
                    }
                    _papersCountStr = responseObject[@"paper_num"];
                    _aboutMeStr = responseObject[@"service_aboutme"];
                    _service_telStr = responseObject[@"service_tel"];
                    [self.backTableView reloadData];
                    
                }else{
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的信息失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }];
        if (!_hasCurrentUser) {//通知tableviewheader为用户头像header
            _hasCurrentUser = YES;
            [self.backTableView reloadData];
        }
    }else{//用户还未登录
        if (_hasCurrentUser) {//通知tableViewheader为注册header
            _hasCurrentUser = NO;
            [self.backTableView reloadData];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSString *)titleName {
    return @"我的";
}

//MARK: Helper
- (void) setupLoginHeaderView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"bg_mine_head_login"];
    self.loginHeaderView = imageView;
    
    UIButton *registerBtn = [[UIButton alloc]init];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(userRegister) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
    self.registerButton = registerBtn;
    registerBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *registerBtnWidthCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *registerBtnHeightCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    NSLayoutConstraint *registerBtnTrailingCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:-24];
    NSLayoutConstraint *registerBtnCenterYCon = [NSLayoutConstraint constraintWithItem:registerBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [imageView addSubview:registerBtn];
    [imageView addConstraints:@[registerBtnWidthCon,registerBtnHeightCon,registerBtnTrailingCon,registerBtnCenterYCon]];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
    [loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton = loginBtn;
    loginBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *loginBtnWidthCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *loginBtnHeightCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
    NSLayoutConstraint *loginBtnTrailingCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:24];
    NSLayoutConstraint *loginBtnCenterYCon = [NSLayoutConstraint constraintWithItem:loginBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [imageView addSubview:loginBtn];
    [imageView addConstraints:@[loginBtnWidthCon,loginBtnHeightCon,loginBtnTrailingCon,loginBtnCenterYCon]];
    
    
    UIView *whiteLine = [[UIView alloc]init];
    whiteLine.backgroundColor = [UIColor whiteColor];
    whiteLine.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *whiteLineWidthCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1];
    NSLayoutConstraint *whiteLineCenterXCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *whiteLineCenterYCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *whiteLineHeightCon = [NSLayoutConstraint constraintWithItem:whiteLine attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:25];
    [imageView addSubview:whiteLine];
    [imageView addConstraints:@[whiteLineWidthCon,whiteLineHeightCon,whiteLineCenterXCon,whiteLineCenterYCon]];
    
    
    
}

- (void) setupUserHeaderView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"bg_mine_head_login"];
    self.userHeaderView = imageView;
    UIButton *headImageBtn = [[UIButton alloc]init];
    _userHeaderImageBtn = headImageBtn;
    [headImageBtn addTarget:self action:@selector(changeUserHeadImage) forControlEvents:UIControlEventTouchUpInside];
    headImageBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *headImageBtnWidthCon = [NSLayoutConstraint constraintWithItem:headImageBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *headImageBtnHeightCon = [NSLayoutConstraint constraintWithItem:headImageBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80];
    NSLayoutConstraint *headImageBtnCenterXCon = [NSLayoutConstraint constraintWithItem:headImageBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *headImageBtnCenterYCon = [NSLayoutConstraint constraintWithItem:headImageBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-17];
    [imageView addSubview:headImageBtn];
    [imageView addConstraints:@[headImageBtnWidthCon,headImageBtnHeightCon,headImageBtnCenterYCon,headImageBtnCenterXCon]];
    
    
    
    UIImageView *cameraImageView = [[UIImageView alloc]init];
    cameraImageView.image = [UIImage imageNamed:@"user_camera"];

    cameraImageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cameraImageViewWidthCon = [NSLayoutConstraint constraintWithItem:cameraImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *cameraImageViewHeightCon = [NSLayoutConstraint constraintWithItem:cameraImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *cameraImageViewTrailingCon = [NSLayoutConstraint constraintWithItem:cameraImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:headImageBtn attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5];
    NSLayoutConstraint *cameraImageViewBottomCon = [NSLayoutConstraint constraintWithItem:cameraImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:headImageBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [headImageBtn addSubview:cameraImageView];
    [headImageBtn addConstraints:@[cameraImageViewBottomCon,cameraImageViewHeightCon,cameraImageViewTrailingCon,cameraImageViewWidthCon]];
    
    UILabel *telLabel = [[UILabel alloc]init];
    telLabel.textAlignment = NSTextAlignmentCenter;
    telLabel.textColor = [UIColor whiteColor];
    telLabel.font = [UIFont systemFontOfSize:15];
    _userTelLabel = telLabel;
    telLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *telLabelWidthCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:194];
    NSLayoutConstraint *telLabelHeightCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:21];
    NSLayoutConstraint *telLabelTopCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headImageBtn attribute:NSLayoutAttributeBottom multiplier:1 constant:8];
    NSLayoutConstraint *telLabelCenterXCon = [NSLayoutConstraint constraintWithItem:telLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [imageView addSubview:telLabel];
    [imageView addConstraints:@[telLabelCenterXCon,telLabelHeightCon,telLabelTopCon,telLabelWidthCon]];
    
    
}

- (void) userRegister
{
    RegisterViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"register"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void) userLogin
{
    LoginViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)changeUserHeadImage
{
    ChangeUserHeadImageViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"changeuserheadimage"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)popupDisplayTypeChoosingActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择职业" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"学生" otherButtonTitles:@"教师", nil];
    [sheet showInView:self.view];
}

//MARK: UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        if (kUserRoleStudent != [UserSession sharedInstance].currentRole) {
            [UserSession sharedInstance].currentRole = kUserRoleStudent;
            MainViewController *parentController = (MainViewController *)self.parentViewController;
            parentController.tabbar.tabBarDisplayType = MainTabBarDisplayTypeStudent;
            [self.backTableView reloadData];
        }
        
    }else if(1 == buttonIndex){
        if (kUserRoleTeacher != [UserSession sharedInstance].currentRole) {
            [UserSession sharedInstance].currentRole = kUserRoleTeacher;
            MainViewController *parentController = (MainViewController *)self.parentViewController;
            parentController.tabbar.tabBarDisplayType = MainTabBarDisplayTypeTeacher;
            [self.backTableView reloadData];
        }
    }
    UserRole currentRole = [[UserSession sharedInstance] currentRole];
    NSDictionary *info = @{kUserRole:@(currentRole)};
    [[UserSession sharedInstance] saveUserProfileWithInfo:info];
}
//MARK: TabelViewDataSource,Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (/* DISABLES CODE */ (1)) // 登陆状态
    {
        return section == 0 ? 6 : 3;
    }else
    {
        return section == 0 ? 3 : 3;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section == 0)
    {
        cell.titleLabel.text = _titles[indexPath.row];
        cell.headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercell%lu",indexPath.row + 1]];
        if (0 == indexPath.row) {
            cell.contentLabel.text = _unReadMessageCountStr;
            cell.contentLabel.textColor = [UIColor redColor];
        }else if (4 == indexPath.row) {
            cell.contentLabel.text = (kUserRoleStudent == [UserSession sharedInstance].currentRole)?@"学生":@"教师";
            cell.contentLabel.textColor = [UIColor blackColor];
        }else if(5 == indexPath.row){
            cell.contentLabel.text = _papersCountStr;
            cell.contentLabel.textColor = [UIColor redColor];
        }else
            cell.contentLabel.text = @"";

    }else if (indexPath.section == 1)
    {
        cell.titleLabel.text = _titles[indexPath.row + 6];
        cell.headImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"usercell%lu",indexPath.row + 7]];
        if (2 == indexPath.row) {
            cell.contentLabel.text = _service_telStr;
            cell.contentLabel.textColor = [UIColor blackColor];
        }else cell.contentLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 130;
    };
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        if (!_hasCurrentUser) {
            return self.loginHeaderView;
        }else
            return self.userHeaderView;
    }else
        return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *colorString = nil;
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                colorString = @"green"; // 我的消息
                break;
            case 1:
                colorString = @"yellow"; // 个人信息
                break;
            case 2:
                colorString = @"orange"; // 我的账户
                break;
            case 3:
                colorString = @"pink";  // 我的邀请
                break;
            case 4:
                [self popupDisplayTypeChoosingActionSheet];
                break;
            case 5:
                colorString = @"gray";  // 我的论文
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                colorString = @"blue"; // 关于我们
                break;
            case 1:
                colorString = @"purple"; // 意见反馈
                break;

            
            default:
                break;
        }
    }
    
    if (colorString.length > 0)
    {
        [self performSegueWithIdentifier:colorString sender:nil];
    }


}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"blue"]) {
        AboutUsViewController *vc = segue.destinationViewController;
        vc.content = _aboutMeStr;
        
    }
    
}



@end
