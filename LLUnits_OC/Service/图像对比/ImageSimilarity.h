//
//  ImageSimilarity.h
//  LLUnits_OC
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageSimilarity : NSObject

// 直接对比图片
+ (BOOL)isSimilarityValueWithImgA:(UIImage*)imgA imgB:(UIImage*)imgB;

// 对比图片的hash值
+ (BOOL)isSimilarityValueWithHashA:(NSString *)hashA hashB:(NSString *)hashB;

// 获取图片的hash值
+ (NSString *)getHashValue:(UIImage *)img;

@end
