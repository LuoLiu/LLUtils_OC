//
//  LLPermissionManager.m
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "LLPermissionManager.h"

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <EventKit/EventKit.h>
#import <Contacts/Contacts.h>
#import <Speech/Speech.h>
#import <HealthKit/HealthKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#import "LLAlertHelper.h"

#define APPDisplayName    [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]

static LLPermissionManager *sharedManager = nil;
static NSInteger const LLPermissionTypeLocationDistanceFilter = 10; //`Positioning accuracy` -> 定位精度

@implementation LLPermissionManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)accessLLPermissionWithType:(LLPermissionType)type completion:(void(^)(BOOL response))completion {
    switch (type) {
        case LLPermissionTypePhoto: {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
                [self showCustomRequestAlertWithPermissionName:@"照片"];
                return;
            }
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    completion(YES);
                } else {
                    completion(NO);
                }
            }];
        }
            break;
            
        case LLPermissionTypeCamera: {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
                [self showCustomRequestAlertWithPermissionName:@"相机"];
                return;
            }
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    completion(YES);
                } else {
                    completion(NO);
                }
            }];
        }
            break;
            
        case LLPermissionTypeMedia: {
            if (@available(iOS 9.3, *)) {
                MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
                if (status == MPMediaLibraryAuthorizationStatusDenied || status == MPMediaLibraryAuthorizationStatusRestricted) {
                    [self showCustomRequestAlertWithPermissionName:@"媒体资料库"];
                    return;
                }
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
            } else {
                NSLog(@"'MPMediaLibrary' is only available on iOS 10.0 or newer");
            }
        }
            break;
            
        case LLPermissionTypeMicrophone: {
            AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
                [self showCustomRequestAlertWithPermissionName:@"麦克风"];
                return;
            }
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    completion(YES);
                } else {
                    completion(NO);
                }
            }];
        }
            break;
            
        case LLPermissionTypeLocation: {
            if ([CLLocationManager locationServicesEnabled]) {
                CLLocationManager *locationManager = [[CLLocationManager alloc]init];
                [locationManager requestAlwaysAuthorization];
                [locationManager requestWhenInUseAuthorization];
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
                locationManager.distanceFilter = LLPermissionTypeLocationDistanceFilter;
                [locationManager startUpdatingLocation];
            }
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
                [self showCustomRequestAlertWithPermissionName:@"位置"];
                return;
            }
            if (status == kCLAuthorizationStatusAuthorizedAlways) {
                completion(YES);
            } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                completion(YES);
            } else {
                completion(NO);
            }
        }
            break;
            
        case LLPermissionTypeBluetooth: {
            if (@available(iOS 10.0, *)) {
                CBCentralManager *centralManager = [[CBCentralManager alloc] init];
                CBManagerState state = [centralManager state];
                if (state == CBManagerStateUnsupported || state == CBManagerStateUnauthorized || state == CBManagerStateUnknown) {
                    completion(NO);
                } else {
                    completion(YES);
                }
            } else {
                NSLog(@"'CBManagerState' is only available on iOS 10.0 or newer");
            }
        }
            break;
            
        case LLPermissionTypePushNotification: {
            if (@available(iOS 10.0, *)) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions types = UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
            } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
            }
#pragma clang diagnostic pop
        }
            break;
            
        case LLPermissionTypeSpeech: {
            if (@available(iOS 10.0, *)) {
                SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
                if (status == SFSpeechRecognizerAuthorizationStatusDenied || status == SFSpeechRecognizerAuthorizationStatusRestricted) {
                    [self showCustomRequestAlertWithPermissionName:@"语音识别"];
                    return;
                }
                [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                    if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
            } else {
                NSLog(@"'SFSpeechRecognizer' is only available on iOS 10.0 or newer");
            }
        }break;
            
        case LLPermissionTypeEvent: {
            EKEventStore *store = [[EKEventStore alloc] init];
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
            if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted) {
                [self showCustomRequestAlertWithPermissionName:@"日历"];
                return;
            }
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    completion(YES);
                } else {
                    completion(NO);
                }
            }];
        }
            break;
            
        case LLPermissionTypeContact: {
            if (@available(iOS 9.0, *)) {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
                    [self showCustomRequestAlertWithPermissionName:@"通讯录"];
                    return;
                }
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        completion(YES);
                    } else {
                        completion(NO);
                    }
                }];
            } else {
                NSLog(@"'CNContactStore' is only available on iOS 10.0 or newer");
            }
        }
            break;
            
        case LLPermissionTypeReminder: {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
            if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted) {
                [self showCustomRequestAlertWithPermissionName:@"日历"];
                return;
            }
            [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    completion(YES);
                } else {
                    completion(NO);
                }
            }];
        }
            break;
        default:
            break;
    }
}

// 弹框提示跳转到系统设置界面
- (void)showCustomRequestAlertWithPermissionName:(NSString *)permissionName {
    NSString *message = [NSString stringWithFormat:@"%@需要获取您的%@权限，请到系统设置页面进行授权", APPDisplayName, permissionName];
    [LLAlertHelper showAlert:@"提示" message:message allow:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } cancel:^(UIAlertAction *action) {
        //
    }];
}

@end
