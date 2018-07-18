//
//  UIImage+Color.m
//  LLUnits_OC
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

/**
 *  @brief  根据颜色生成纯色图片
 *  @param color 颜色
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
