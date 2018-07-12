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

+ (void)showAlert:(UIAlertController *)alert;

+ (UIViewController *)topViewController;

@end
