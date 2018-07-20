//
//  UIViewController+BarItem.m
//  LLUnits_OC
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "UIViewController+BarItem.h"
#import "UIImage+Color.h"

@implementation UIViewController (BarItem)

// 设置导航栏背景色和标题
- (void)addNavigationBarWithTitle:(NSString *)title {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                [UIFont boldSystemFontOfSize:15], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self setTitle:title];
    
    UIColor *color = [UIColor colorWithHexString:@"#547ACA"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
}

// 设置导航栏是否透明
- (void)setNavigationBarTransparent:(BOOL)transparent {
    if (transparent) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    } else {
        UIColor *color = [UIColor colorWithHexString:@"#547ACA"];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    }
}

// 添加返回按钮
- (void)addBackButton {
    UIImage *image = [[UIImage imageNamed:@"bar_btn_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:item];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

// 添加自定义按钮 (左)
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action {
    UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:originalImage style:UIBarButtonItemStylePlain target:self action:action];
    [self.navigationItem setLeftBarButtonItem:item];
}

// 添加自定义按钮 (右)
- (void)addRightBarButtonWithImage:(UIImage *)image action:(SEL)action {
    UIImage *originalImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:originalImage style:UIBarButtonItemStylePlain target:self action:action];
    [self.navigationItem setRightBarButtonItem:item];
}

@end
