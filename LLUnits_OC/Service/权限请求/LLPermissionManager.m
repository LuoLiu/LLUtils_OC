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

- (void)accessLLPermissionWithType:(LLPermissionType)type completion:(void(^)(BOOL response, LLPermissionAuthorizationStatus status))completion {
    switch (type) {
        case LLPermissionTypePhoto: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusDenied) {
                    completion(NO,LLPermissionAuthorizationStatusDenied);
                } else if (status == PHAuthorizationStatusNotDetermined) {
                    completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                } else if (status == PHAuthorizationStatusRestricted) {
                    completion(NO,LLPermissionAuthorizationStatusRestricted);
                } else if (status == PHAuthorizationStatusAuthorized) {
                    completion(YES,LLPermissionAuthorizationStatusAuthorized);
                }
            }];
        }break;
            
        case LLPermissionTypeCamera: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (granted) {
                    completion(YES,LLPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == AVAuthorizationStatusDenied) {
                        completion(NO,LLPermissionAuthorizationStatusDenied);
                    } else if (status == AVAuthorizationStatusNotDetermined) {
                        completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                    } else if (status == AVAuthorizationStatusRestricted) {
                        completion(NO,LLPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
        case LLPermissionTypeMedia: {
            if (@available(iOS 9.3, *)) {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                    if (status == MPMediaLibraryAuthorizationStatusDenied) {
                        completion(NO,LLPermissionAuthorizationStatusDenied);
                    } else if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
                        completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                    } else if (status == MPMediaLibraryAuthorizationStatusRestricted) {
                        completion(NO,LLPermissionAuthorizationStatusRestricted);
                    } else if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                        completion(YES,LLPermissionAuthorizationStatusAuthorized);
                    }
                }];
            } else {
                NSLog(@"'MPMediaLibrary' is only available on iOS 10.0 or newer");
            }
        }break;
            
        case LLPermissionTypeMicrophone: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                if (granted) {
                    completion(YES,LLPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == AVAuthorizationStatusDenied) {
                        completion(NO,LLPermissionAuthorizationStatusDenied);
                    } else if (status == AVAuthorizationStatusNotDetermined) {
                        completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                    } else if (status == AVAuthorizationStatusRestricted) {
                        completion(NO,LLPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }break;
            
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
            if (status == kCLAuthorizationStatusAuthorizedAlways) {
                completion(YES,LLPermissionAuthorizationStatusLocationAlways);
            } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
                completion(YES,LLPermissionAuthorizationStatusLocationWhenInUse);
            } else if (status == kCLAuthorizationStatusDenied) {
                completion(NO,LLPermissionAuthorizationStatusDenied);
            } else if (status == kCLAuthorizationStatusNotDetermined) {
                completion(NO,LLPermissionAuthorizationStatusNotDetermined);
            } else if (status == kCLAuthorizationStatusRestricted) {
                completion(NO,LLPermissionAuthorizationStatusRestricted);
            }
        }break;
            
        case LLPermissionTypeBluetooth: {
            if (@available(iOS 10.0, *)) {
                CBCentralManager *centralManager = [[CBCentralManager alloc] init];
                CBManagerState state = [centralManager state];
                if (state == CBManagerStateUnsupported || state == CBManagerStateUnauthorized || state == CBManagerStateUnknown) {
                    completion(NO,LLPermissionAuthorizationStatusDenied);
                } else {
                    completion(YES,LLPermissionAuthorizationStatusAuthorized);
                }
            } else {
                NSLog(@"'CBManagerState' is only available on iOS 10.0 or newer");
            }
        }
            break;
            
        case LLPermissionTypePushNotification: {
            if (@available(iOS 10.0, *)) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                UNAuthorizationOptions types=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
                [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                            //
                        }];
                    } else {
                        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@""} completionHandler:^(BOOL success) { }];
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
                [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                    if (status == SFSpeechRecognizerAuthorizationStatusDenied) {
                        completion(NO,LLPermissionAuthorizationStatusDenied);
                    } else if (status == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
                        completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                    } else if (status == SFSpeechRecognizerAuthorizationStatusRestricted) {
                        completion(NO,LLPermissionAuthorizationStatusRestricted);
                    } else if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                        completion(YES,LLPermissionAuthorizationStatusAuthorized);
                    }
                }];
            } else {
                NSLog(@"'SFSpeechRecognizer' is only available on iOS 10.0 or newer");
            }
        }break;
            
        case LLPermissionTypeEvent: {
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted) {
                    completion(YES,LLPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == EKAuthorizationStatusDenied) {
                        completion(NO,LLPermissionAuthorizationStatusDenied);
                    } else if (status == EKAuthorizationStatusNotDetermined) {
                        completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                    } else if (status == EKAuthorizationStatusRestricted) {
                        completion(NO,LLPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }
            break;
            
        case LLPermissionTypeContact: {
            if (@available(iOS 9.0, *)) {
                CNContactStore *contactStore = [[CNContactStore alloc] init];
                [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
                    if (granted) {
                        completion(YES,LLPermissionAuthorizationStatusAuthorized);
                    } else {
                        if (status == CNAuthorizationStatusDenied) {
                            completion(NO,LLPermissionAuthorizationStatusDenied);
                        } else if (status == CNAuthorizationStatusRestricted) {
                            completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                        } else if (status == CNAuthorizationStatusNotDetermined) {
                            completion(NO,LLPermissionAuthorizationStatusRestricted);
                        }
                    }
                }];
            } else {
                NSLog(@"'CNContactStore' is only available on iOS 10.0 or newer");
            }
        }
            break;
            
        case LLPermissionTypeReminder: {
            EKEventStore *eventStore = [[EKEventStore alloc] init];
            [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
                if (granted) {
                    completion(YES,LLPermissionAuthorizationStatusAuthorized);
                } else {
                    if (status == EKAuthorizationStatusDenied) {
                        completion(NO,LLPermissionAuthorizationStatusDenied);
                    } else if (status == EKAuthorizationStatusNotDetermined) {
                        completion(NO,LLPermissionAuthorizationStatusNotDetermined);
                    } else if (status == EKAuthorizationStatusRestricted) {
                        completion(NO,LLPermissionAuthorizationStatusRestricted);
                    }
                }
            }];
        }
            break;
        default:
            break;
    }
}

@end
