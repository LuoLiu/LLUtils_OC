//
//  UIViewController+BarItem.h
//  LLUnits_OC
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (BarItem)

// 设置导航栏背景色和标题
- (void)addNavigationBarWithColor:(UIColor *)bgColor title:(NSString *)title;

// 设置导航是否透明
- (void)setNavigationBarTransparent:(BOOL)transparent;

// 添加自定义按钮 (左)
- (void)addLeftBarButtonWithImage:(UIImage *)image action:(SEL)action;

// 添加自定义按钮 (右)
- (void)addRightBarButtonWithImage:(UIImage *)image action:(SEL)action;

@end
