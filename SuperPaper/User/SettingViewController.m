//
//  SettingViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/23.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "SettingViewController.h"
#import "ResetPasswordViewController.h"
#import "UserSession.h"
#import "AppConfig.h"
#import "UserSettingHasNextTableViewCell.h"
#import "UserSettingRadioTableViewCell.h"
#import "UserSettingTextShowTableViewCell.h"
#import "UserSettingLogoutTableViewCell.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL _currentUserHasLogin;//当前已登录
    UIView *_securityHeaderView;//安全设置header
    UIView *_appHeaderView;//应用设置header
    UISwitch *_soundEffectSwitch;//音效开关
    UISwitch *_acceptPushNotificationSwitch;//接受通知开关
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *hasNextIdentifier = @"hasnext";
static NSString *radioIdentifier = @"radio";
static NSString *textShowIdentifier = @"textshow";
static NSString *logoutIdentifier = @"logout";
@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (0 == [UserSession sharedInstance].currentUserID) {
        _currentUserHasLogin = NO;
    }else
        _currentUserHasLogin = YES;
    [self setupAppHeaderView];
    [self setupSecurityHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Helper
/**
 *  设置安全设置headers
 */
- (void)setupSecurityHeaderView
{
    UIView *securityHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    securityHeaderView.backgroundColor = [AppConfig viewBackgroundColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 7, 100, 30)];
    label.text = @"安全设置";
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor lightGrayColor]];
    [securityHeaderView addSubview:label];
    _securityHeaderView = securityHeaderView;
}
/**
 *  设置应用设置headers
 */
- (void)setupAppHeaderView
{
    UIView *appHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    appHeaderView.backgroundColor = [AppConfig viewBackgroundColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 7, 100, 30)];
    label.text = @"应用设置";
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor lightGrayColor]];
    [appHeaderView addSubview:label];
    _appHeaderView = appHeaderView;
}
//MARK: UITableViewDataSource,Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_currentUserHasLogin) {//当前用户未登录
        return 1;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentUserHasLogin) {//当前用户已登录
        if (0 == section) {
            return 1;
        }
        return 4;
    }else{//当前用户未登录
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.row) {
        return 80;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_currentUserHasLogin) {
        if (0 == indexPath.row) {
            UserSettingRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:radioIdentifier];
            cell.titleLabel.text = @"音效";
            [cell.titleLabel sizeToFit];
            _soundEffectSwitch = cell.switchView;
            [_soundEffectSwitch addTarget:self action:@selector(soundEffect:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        }else if(1 == indexPath.row){
            UserSettingRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:radioIdentifier];
            cell.titleLabel.text = @"接受通知";
            [cell.titleLabel sizeToFit];
            _acceptPushNotificationSwitch = cell.switchView;
            [_acceptPushNotificationSwitch addTarget:self action:@selector(soundEffect:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }else{
            UserSettingTextShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textShowIdentifier];
            cell.titleLabel.text = @"清除缓存";
            [cell.titleLabel sizeToFit];
            cell.contentLabel.text = @"10.8888MB";
            [cell.contentLabel sizeToFit];
            return cell;
        }
            
    }else{//当前已登录
        if (0 == indexPath.section) {
            UserSettingHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hasNextIdentifier];
            cell.titleLabel.text = @"修改密码";
            [cell.titleLabel sizeToFit];
            return cell;
        }else{
            if (0 == indexPath.row) {
                UserSettingRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:radioIdentifier];
                cell.titleLabel.text = @"音效";
                [cell.titleLabel sizeToFit];
                _soundEffectSwitch = cell.switchView;
                [_soundEffectSwitch addTarget:self action:@selector(soundEffect:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if(1 == indexPath.row){
                UserSettingRadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:radioIdentifier];
                cell.titleLabel.text = @"接受通知";
                [cell.titleLabel sizeToFit];
                _acceptPushNotificationSwitch = cell.switchView;
                [_acceptPushNotificationSwitch addTarget:self action:@selector(soundEffect:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if(2 == indexPath.row){
                UserSettingTextShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:textShowIdentifier];
                cell.titleLabel.text = @"清除缓存";
                [cell.titleLabel sizeToFit];
                cell.contentLabel.text = @"10.8MB";
                [cell.contentLabel sizeToFit];
                return cell;
            }else{
                UserSettingLogoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutIdentifier];
                cell.superVC = self;
                return cell;
            }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!_currentUserHasLogin) {
        return _appHeaderView;
    }else{
        if (0 == section) {
            return _securityHeaderView;
        }else
            return _appHeaderView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentUserHasLogin) {
        if (0 == indexPath.section) {
            ResetPasswordViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"resetpwd"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

//MARK: 选择开关
-(void)soundEffect:(UISwitch *)sender
{
    if (sender == _soundEffectSwitch) {
        if (!sender.on) {
            
        }else{
            
        }
            
    }else{
        if (!sender.on) {
            
        }else{
            
        }
        
    }
}
//MARK: 功能
- (void)logout
{
    UserSession *session = [UserSession sharedInstance];
    
    [session setCurrentUserID:0];
    
    [session setCurrentRole:kUserRoleStudent];
    
    [session setCurrentUserName:nil];
    
    
    [session setCurrentUserNickname:nil];
    
    
    
    [session setLastUserTelNum:session.currentUserTelNum];
    
    
    [session setCurrentUserTelNum:nil];
    
    
    [session setCurrentUserGen:kUserGen_Man];
    
    
    [session setCurrentUserAge:0];
    
    
    [session setCurrentUserHeadImageName:nil];
    
    
    [session setCurrentUserCollege:nil];
    
    [session setCurrentUserInviteCode:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
