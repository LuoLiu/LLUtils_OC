//
//  UIImage+Color.h
//  LLUnits_OC
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 *  @brief  根据颜色生成纯色图片
 *  @param color 颜色
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
