//
//  InvitationsViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "InvitationsViewController.h"
#import "InvitationsTableViewCell.h"

@interface InvitationsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *myFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

static NSString *const InvitationIdentifier = @"Invitation";
@implementation InvitationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *urlString = [NSString stringWithFormat:@"%@myinvite.php",BASE_URL];
//    NSDictionary *params = @{@"myinvite_code":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
}
- (IBAction)showMyFriends:(id)sender {
}
- (IBAction)iwanttoshare:(id)sender {
}

//MARK:TableViewDataSource, Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvitationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationIdentifier];
    return cell;
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
