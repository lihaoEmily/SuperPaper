//
//  AboutUsViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/10.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "AboutUsViewController.h"
#import "CheckAboutUsViewController.h"
#import "ServiceNoticesViewController.h"
#import "AboutUsHasNextTableViewCell.h"
#import "VersionTableViewCell.h"
#import "AppInfo.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titles;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

static NSString *const HasNextIdentifier = @"HasNext";
static NSString *const VersionIdentifier = @"Version";
@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titles = @[@"服务条款",
                @"关于我们"
                ];
    self.imageView.image = [UIImage imageWithASName:@"default_image" directory:@"common"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TableViewDataSource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        AboutUsHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleLabel.text = _titles[indexPath.row];
        return cell;
    }else{
        VersionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VersionIdentifier];
         cell.versionLabel.text = [NSString stringWithFormat:@"版本V%@",[AppInfo appCurrentVersion]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        ServiceNoticesViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"serviceitems"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(1 == indexPath.row){
        CheckAboutUsViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"aboutus"];
        vc.content = self.content;
        [self.navigationController pushViewController:vc animated:YES];
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
