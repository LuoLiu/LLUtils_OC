//
//  LLAlertHelper.h
//  LLUnits_OC
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HandleAction)(void);

@interface LLAlertHelper : NSObject

// 普通提示框
+ (void)showAlert:(NSString *)title message:(NSString*)message;

// 询问提示框
+ (void)showAlert:(NSString *)title
          message:(NSString*)message
            allow:(void (^ __nullable)(UIAlertAction *action))allowHandler
           cancel:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

// 显示弹框
+ (void)showAlert:(UIAlertController *)alert;

// 获取顶层视图控制器
+ (UIViewController *)topViewController;

@end
