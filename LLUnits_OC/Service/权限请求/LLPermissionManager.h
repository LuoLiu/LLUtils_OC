//
//  LLPermissionManager.h
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LLPermissionType) {
    LLPermissionTypePhoto = 0,          // 相册
    LLPermissionTypeCamera,             // 相机
    LLPermissionTypeMedia,              // 媒体资料库
    LLPermissionTypeMicrophone,         // 麦克风
    LLPermissionTypeLocation,           // 位置
    LLPermissionTypeBluetooth,          // 蓝牙
    LLPermissionTypePushNotification,   // 推送
    LLPermissionTypeSpeech,             // 语音识别
    LLPermissionTypeEvent,              // 日历
    LLPermissionTypeContact,            // 通讯录
    LLPermissionTypeReminder,           // 提醒事项
};

typedef NS_ENUM(NSUInteger, LLPermissionAuthorizationStatus) {
    LLPermissionAuthorizationStatusAuthorized = 0,
    LLPermissionAuthorizationStatusDenied,
    LLPermissionAuthorizationStatusNotDetermined,
    LLPermissionAuthorizationStatusRestricted,
    LLPermissionAuthorizationStatusLocationAlways,
    LLPermissionAuthorizationStatusLocationWhenInUse,
    LLPermissionAuthorizationStatusUnkonwn,
};

@interface LLPermissionManager : NSObject

+ (instancetype)sharedManager;

/**
 * @brief `Function for access the permissions` -> 获取权限函数
 * @param type `The enumeration type for access permission` -> 获取权限枚举类型
 * @param completion `A block for the permission result and the value of authorization status` -> 获取权限结果和对应权限状态的block
 */
- (void)accessLLPermissionWithType:(LLPermissionType)type completion:(void(^)(BOOL response, LLPermissionAuthorizationStatus status))completion;

@end
