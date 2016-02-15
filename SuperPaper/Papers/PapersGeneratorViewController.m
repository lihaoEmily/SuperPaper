//
//  PapersGeneratorViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersGeneratorViewController.h"
#import "ASSaveData.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PapersGeneratorViewController ()<UITextFieldDelegate>

@end

@implementation PapersGeneratorViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 搜索框
    UITextField *_searchBar;
    
    /// 显示论文的label
    UILabel *_paperLabel;
    
    /// 生成的论文
    NSString *_content;
    
    // searchBar的容器View
    UIView *_searchBgView;
    
    /// 显示论文的scrollView
    UITextView *_paperTextView;
    
    UIView *_lineView;
    
    UIActivityIndicatorView *_activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _content = @"";
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI
{
    _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    
    [self.view addSubview:_searchBgView];
    
    // 灰色背景图片
    UIImageView *searchBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"generatorBox" ofType:@"png" inDirectory:@"Paper"]];
    searchBgImg.image = image;
    [_searchBgView addSubview:searchBgImg];
    searchBgImg.userInteractionEnabled = YES;
    
    UILabel *topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 55, 30)];
    topicLabel.text = @"题目：";
    topicLabel.textColor = [UIColor blackColor];
    topicLabel.font = [UIFont systemFontOfSize:18.0];
    [searchBgImg addSubview:topicLabel];
    
    // 白色背景图片
    UIImageView *searchBarImg = [[UIImageView alloc] initWithFrame:CGRectMake(65, 5, kScreenWidth - 140, 40)];
    UIImage *searchBarImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBar" ofType:@"png" inDirectory:@"Paper"]];
    searchBarImg.image = searchBarImage;
    [searchBgImg addSubview:searchBarImg];
    searchBarImg.userInteractionEnabled = YES;
    
    // 搜索textfield
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, searchBarImg.frame.size.width - 5, 40)];
    _searchBar.layer.cornerRadius = 5;
    _searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchBar.placeholder = @"请输入论文题目";
    _searchBar.delegate = self;
    _searchBar.clearButtonMode = UITextFieldViewModeAlways;
    [searchBarImg addSubview:_searchBar];
    
    // 右侧文字搜索button
    UIButton *generatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    generatorBtn.frame = CGRectMake(CGRectGetMaxX(searchBarImg.frame) + 5, 5, 60, _searchBar.frame.size.height);
    generatorBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [generatorBtn setTitle:@"生成" forState:UIControlStateNormal];
    [generatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [generatorBtn addTarget:self action:@selector(clickToGenerator) forControlEvents:UIControlEventTouchUpInside];;
    UIImage *generatorBtnImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"generator" ofType:@"png" inDirectory:@"Paper"]];
    [generatorBtn setBackgroundImage:generatorBtnImage forState:UIControlStateNormal];
    [searchBgImg addSubview:generatorBtn];
    
    /// 底部导出论文的背景图片
    UIImageView *exportBoxImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 114, kScreenWidth, 50)];
    UIImage *exportBoxImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"exportBox" ofType:@"png" inDirectory:@"Paper"]];
    exportBoxImg.image = exportBoxImage;
    [self.view addSubview:exportBoxImg];
    exportBoxImg.userInteractionEnabled = YES;
    
    UILabel *exportLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 40)];
    exportLabel.text = @"导出：";
    exportLabel.textColor = [UIColor blackColor];
    exportLabel.font = [UIFont systemFontOfSize:18.0];
    [exportBoxImg addSubview:exportLabel];
    
    /// txtIcon按钮
    UIButton *txtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    txtBtn.frame = CGRectMake(CGRectGetMaxX(exportLabel.frame), 10, 30, 30);
    txtBtn.tag = 1001;
    UIImage *txtImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"txtIcon" ofType:@"png" inDirectory:@"Paper"]];
    [txtBtn setBackgroundImage:txtImage forState:UIControlStateNormal];
    [txtBtn addTarget:self action:@selector(exportPapers:) forControlEvents:UIControlEventTouchUpInside];
    [exportBoxImg addSubview:txtBtn];
    
    /// 导出按钮
    UIButton *exportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (kScreenWidth == 375) {
        exportBtn.frame = CGRectMake(CGRectGetMaxX(exportBoxImg.frame) - 52, 10, 45, 30);
    }else if (kScreenWidth == 320){
        exportBtn.frame = CGRectMake(CGRectGetMaxX(exportBoxImg.frame) - 45, 10, 40, 30);
    }else{
        exportBtn.frame = CGRectMake(CGRectGetMaxX(exportBoxImg.frame) - 56, 10, 50, 30);
    }
    exportBtn.tag = 1002;
    UIImage *exportImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"export" ofType:@"png" inDirectory:@"Paper"]];
    [exportBtn setBackgroundImage:exportImage forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(exportPapers:) forControlEvents:UIControlEventTouchUpInside];
    [exportBtn setTitle:@"导出" forState:UIControlStateNormal];
    [exportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    exportBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [exportBoxImg addSubview:exportBtn];
    
    /// 正文预览
    UILabel *textPreviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 80, CGRectGetMaxY(_searchBgView.frame) + 5, 160, 30)];
    textPreviewLabel.font = [UIFont systemFontOfSize:20.0];
    textPreviewLabel.text = @"正文预览";
    textPreviewLabel.textAlignment = NSTextAlignmentCenter;
    textPreviewLabel.textColor = [UIColor blackColor];
    [self.view addSubview:textPreviewLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(textPreviewLabel.frame) + 5, kScreenWidth - 20, 1)];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_lineView];
    
    _paperTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lineView.frame), kScreenWidth, kScreenHeight - 64 - 50 - 60 - 36)];
    _paperTextView.textColor = [UIColor blackColor];
    _paperTextView.font = [UIFont systemFontOfSize:17.0];
    _paperTextView.returnKeyType = UIReturnKeyDone;
    [_paperTextView setEditable:NO];
    [self.view addSubview:_paperTextView];
    
    /// 指示器
    _activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_activity setCenter:CGPointMake(kScreenWidth / 2, CGRectGetMidY(_paperTextView.frame) - 60)];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_paperTextView addSubview:_activity];
}

- (void)setupScrollView
{
    if (_content.length > 0) {
        _paperTextView.text = _content;
    }else{
        UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"超级论文" message:@"无内容生成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alterView show];
    }
}

#pragma mark - action
/// 生成论文
- (void)clickToGenerator
{
    [_activity startAnimating];
    [_searchBar resignFirstResponder];
    if ([_searchBar.text isEqualToString:@""] || _searchBar.text.length == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入论文题目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self getData];
}

- (void)exportPapers:(UIButton *)sender
{
    if (_content) {
        ASSaveData *data = [[ASSaveData alloc] init];
        [data saveToLocationwithStrings:_content withTitle:_searchBar.text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"论文已导出到Documents文件夹中，请注意查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有课导出的论文" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 获取数据
- (void)getData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:54],@"uid",[NSNumber numberWithInteger:1],@"keywordsnum",_searchBar.text,@"keywords",nil];
    NSLog(@"%@",paramDic);
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_create.php",BASE_URL];
    NSLog(@"%@",urlString);
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [_activity stopAnimating];
           NSLog(@"%@",responseObject);
           if ([responseObject valueForKey:@"content"]) {
               _content = [responseObject valueForKey:@"content"];
           }
           [self setupScrollView];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
       }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchBar resignFirstResponder];
    return YES;
}

@end
