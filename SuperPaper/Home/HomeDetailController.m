//
//  HomeDetailController.m
//  SuperPaper
//
//  Created by wendy on 16/1/27.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "HomeDetailController.h"

#define TITLELABEL_H 56
#define NUMLABEL_W   60
#define NUMLABEL_H   20

@interface HomeDetailController ()
{
    UIView *leftView;
    UILabel *titleLabel;
    UILabel *keyLabel;
    UILabel *numOfReader;
    UIImageView *imageView;
    UIImageView *centerImageView;
    UILabel *content;
    UIScrollView *scrollVeiw;
    UILabel *timeLabel;
    NSDictionary *textAttributeDictionary;
}
@end

@implementation HomeDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollVeiw = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    scrollVeiw.backgroundColor = [UIColor redColor];
    [self.view addSubview:scrollVeiw];
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(8, 16, 6, TITLELABEL_H)];
    leftView.backgroundColor = [AppConfig appNaviColor];
    [scrollVeiw addSubview:leftView];
    
//    标题
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)+16, 16, SCREEN_WIDTH-CGRectGetMaxX(leftView.frame)-16 - 20, TITLELABEL_H)];
    titleLabel.font = [UIFont systemFontOfSize:21];
    titleLabel.numberOfLines = 2;
    [scrollVeiw addSubview:titleLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(titleLabel.frame)+ 20, SCREEN_WIDTH - NUMLABEL_W * 2, NUMLABEL_H)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [scrollVeiw addSubview:timeLabel];
    
//    阅读人数
    numOfReader = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - NUMLABEL_W, CGRectGetMaxY(titleLabel.frame)+ 20, NUMLABEL_W, NUMLABEL_H)];
    numOfReader.font = [UIFont systemFontOfSize:14];
    numOfReader.textAlignment = NSTextAlignmentCenter;
    numOfReader.textColor = [UIColor grayColor];
    [scrollVeiw addSubview:numOfReader];
    
//    小眼睛
//    imageView = [[UIImageView alloc]initWithImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ViewCount"]];
    imageView.frame = CGRectMake(SCREEN_WIDTH - NUMLABEL_W - 20, CGRectGetMaxY(titleLabel.frame) + 20, NUMLABEL_H, NUMLABEL_H);
    [scrollVeiw addSubview:imageView];
    
    //关键词
    keyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftView.frame)+10, CGRectGetMaxY(imageView.frame), SCREEN_WIDTH-CGRectGetMaxX(leftView.frame)-10 - 20, TITLELABEL_H)];
    keyLabel.font = [UIFont systemFontOfSize:21];
    keyLabel.numberOfLines = 2;
    [scrollVeiw addSubview:keyLabel];
    
//    中间的图片
    centerImageView = [[UIImageView alloc]init];
    centerImageView.frame = CGRectMake(CGRectGetMaxX(leftView.frame)+10,CGRectGetMaxY(imageView.frame) + 20, SCREEN_WIDTH - (CGRectGetMaxX(leftView.frame)+10)*2, 200);
    [scrollVeiw addSubview:centerImageView];
    
    content = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(centerImageView.frame) + 20, SCREEN_WIDTH-20, 10000)];
//    [content setTextAlignment:NSTextAlignmentCenter];
//    content.font = [UIFont systemFontOfSize:19];
    UIFont *font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 15; // 首行字间矩
    paragraphStyle.headIndent = 15; // 字间矩
    paragraphStyle.lineSpacing = 7; // 行间矩
    textAttributeDictionary = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    content.numberOfLines = 0;
    [scrollVeiw addSubview:content];
    if (self.isNews) {
        [self getDetailwithURL:@"get_newscontent.php"];
    }
    else{
        [self getDetailwithURL:@"get_activitycontent.php"];
    }
}

- (void)getDetailwithURL:(NSString *)urlStr {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     * parameters 参数
     * ownertype  整型
     */
    NSDictionary *parameters = @{@"id":_passId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,urlStr];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"result"]] isEqualToString:@"0"]) {
            [self reloadViewDateWithdict:responseObject];
        }
        NSLog(@"1111 %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"2222");
    }];
}

- (void)reloadViewDateWithdict:(NSDictionary *)dic {
    titleLabel.text = dic[@"title"];
    [titleLabel sizeToFit];
//    content.text = dic[@"content"];
    content.attributedText = [[NSAttributedString alloc] initWithString:dic[@"content"] attributes:textAttributeDictionary];
    [content sizeToFit];
    NSString *time = [NSString stringWithFormat:@"%@",dic[@"createdate"]];
    keyLabel.text = [NSString stringWithFormat:@"%@",dic[@"keywords"]];
    if ([self isBlankString:time] ||  [time isEqualToString:@"(null)"]){
        numOfReader.text = [NSString stringWithFormat:@"%@",dic[@"viewnum"]];
    }
    else {
        if ([time componentsSeparatedByString:@" "].count > 0) {
            timeLabel.text = [time componentsSeparatedByString:@" "][0];
        }
        numOfReader.text = [NSString stringWithFormat:@"%@",dic[@"viewnum"]];
    }
    NSString *imageUrl = [NSString stringWithFormat:@"%@",dic[@"content_pic_name"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",IMGURL,dic[@"content_pic_name"]];
    if ([self isBlankString:imageUrl] ||  [imageUrl isEqualToString:@"<null>"]) {
        CGRect rect = content.frame;
        rect.origin.y = CGRectGetMaxY(imageView.frame) + 10;
        rect.size.height = content.frame.size.height;
        content.frame = rect;
        centerImageView.hidden = YES;
    }
    else{
        [centerImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        centerImageView.hidden = NO;
    }
    scrollVeiw.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(content.frame) + 64 + 10);
}

- (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
