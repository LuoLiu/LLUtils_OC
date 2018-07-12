//
//  UIView+EasyLayout.h
//  LLUnits_OC
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyLayout)

@property (nonatomic) CGFloat es_left;        // Shortcut for frame.origin.x.
@property (nonatomic) CGFloat es_top;         // Shortcut for frame.origin.y
@property (nonatomic) CGFloat es_right;       // Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat es_bottom;      // Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat es_width;       // Shortcut for frame.size.width.
@property (nonatomic) CGFloat es_height;      // Shortcut for frame.size.height.
@property (nonatomic) CGFloat es_centerX;     // Shortcut for center.x
@property (nonatomic) CGFloat es_centerY;     // Shortcut for center.y
@property (nonatomic) CGPoint es_origin;      // Shortcut for frame.origin.
@property (nonatomic) CGSize  es_size;        // Shortcut for frame.size.

@end
