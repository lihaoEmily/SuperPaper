//
//  PublicationViewController.m
//  SuperPaper
//
//  Created by else on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationViewController.h"

@interface PublicationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_leftTable;
    UITableView *_rightTable;
}

@end

@implementation PublicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftTable = [[UITableView alloc] init];
    _leftTable.frame = CGRectMake(0, 0, self.view.bounds.size.width/4, self.view.bounds.size.height);
    _leftTable.dataSource = self;
    _leftTable.delegate = self;
//    _leftTable.backgroundColor = [UIColor grayColor];
//    _leftTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _leftTable.showsVerticalScrollIndicator = NO;
//    _leftTable.tableFooterView = [[UIView alloc] init];
    _leftTable.tag = 1000;
    _leftTable.separatorColor = [UIColor whiteColor];
    _leftTable.separatorInset = UIEdgeInsetsMake(0,0, 0, 0);
    _leftTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_leftTable];
    
    _rightTable = [[UITableView alloc] init];
    _rightTable.frame = CGRectMake(self.view.bounds.size.width/4, 0, self.view.bounds.size.width*3/4, self.view.bounds.size.height);
    _rightTable.dataSource = self;
    _rightTable.delegate = self;
//    _rightTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _rightTable.showsVerticalScrollIndicator = YES;
//    _rightTable.tableFooterView = [[UIView alloc] init];
    _rightTable.tag = 2000;
    [self.view addSubview:_rightTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return 5;
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"left";
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    }else{
        static NSString *CellIdentifier2 = @"Cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        }
        
        cell.textLabel.text = @"right";
        return cell;
    }
}

#pragma mark - tableView 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1000) {
//        [_categoryView show];
    }
    else{
        NSLog(@"tap right tableview index:%ld",(long)indexPath.row);
    }
    
}


@end
