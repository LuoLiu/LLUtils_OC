//
//  LLAlertHelper.m
//  LLUnits_OC
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "LLAlertHelper.h"

@implementation LLAlertHelper

// 普通提示框
+ (void)showAlert:(NSString *)title message:(NSString*)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:nil];
    
    [alert addAction:defaultAction];
    
    [self showAlert:alert];
}

// 询问提示框
+ (void)showAlert:(NSString *)title
          message:(NSString*)message
            allow:(void (^ __nullable)(UIAlertAction *action))allowHandler
           cancel:(void (^ __nullable)(UIAlertAction *action))cancelHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:allowHandler];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                        handler:cancelHandler];
    
    [alert addAction:allowAction];
    [alert addAction:cancelAction];

    [self showAlert:alert];
}

+ (void)showAlert:(UIAlertController *)alert {
    UIViewController *viewController = [[self class] topViewController];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            alert.popoverPresentationController.sourceView = viewController.view;
            alert.popoverPresentationController.sourceRect = CGRectMake(0, viewController.view.frame.size.height-70, viewController.view.frame.size.width, viewController.view.frame.size.height);
        }
        [viewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (UIViewController *)topViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *nav = (UITabBarController *)viewController;
        viewController = nav.selectedViewController;
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        viewController = nav.visibleViewController;
    }
    if (viewController.presentedViewController != nil) {
        viewController = viewController.presentedViewController;
    }
    
    return viewController;
}

@end
