//
//  ASNavigationController.m
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NavigationController.h"

//#define kSelColor  [UIColor colorWithRed:255/255.0 green:6/255.0 blue:108/255.0 alpha:1.0f]

@interface NavigationController ()

@end
@interface  UIImage (colorful)
+ (UIImage *)imageWithColor:(UIColor *)color;
@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (void)initialize
{
    [super initialize];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:[[UIImage imageWithColor:[AppConfig appNaviColor]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forBarMetrics:UIBarMetricsDefault];
    
    navBar.backgroundColor = [UIColor clearColor];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    
    UIBarButtonItem *btnItem = [UIBarButtonItem appearance];
    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
    dictM[NSForegroundColorAttributeName] = [UIColor clearColor];
    dictM[NSFontAttributeName] = [UIFont systemFontOfSize:0];

    NSShadow * shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    dictM[NSShadowAttributeName] = shadow;
    [btnItem setTitleTextAttributes:dictM forState:UIControlStateNormal];

    NSMutableDictionary * highdictM = [NSMutableDictionary dictionaryWithDictionary:dictM];
    highdictM[NSForegroundColorAttributeName] = [UIColor clearColor];
    [btnItem setTitleTextAttributes:highdictM forState:UIControlStateHighlighted];
    
    NSMutableDictionary * disableDictM = [NSMutableDictionary dictionary];
    disableDictM[NSForegroundColorAttributeName] = [UIColor clearColor];
    [btnItem setTitleTextAttributes:disableDictM forState:UIControlStateDisabled];
    
    // 系统自带的导航条，在标题文字很长时，进入到下一个界面，而下一个界面的标题也很长时，就会出现标题不居中显示。因此这里，我们需要使用自定义的返回箭头，而且不显示返回按钮的文字。
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    // 但是，仅仅部分标题是正常显示，还是有一些地方有不居中的。因此，我们还需要再添加一些代码解决。
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:1]};
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
}



- (void)back{
    [self popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{
    
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end