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
- (void)addNavigationBarWithColor:(UIColor *)bgColor title:(NSString *)title {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                [UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self setTitle:title];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:bgColor] forBarMetrics:UIBarMetricsDefault];
}

// 设置导航栏是否透明
- (void)setNavigationBarTransparent:(BOOL)transparent {
    if (transparent) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    } else {
        // TODO: 不透明时自定义样式
    }
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
