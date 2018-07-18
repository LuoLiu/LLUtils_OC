//
//  UIColor+Hex.h
//  LLUnits_OC
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

// color: @“#123456”、 @“0X123456”、 @“123456”
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

@end
