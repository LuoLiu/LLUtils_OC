//
//  UIView+EasyLayout.m
//  LLUnits_OC
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "UIView+EasyLayout.h"

@implementation UIView (EasyLayout)

- (CGFloat)es_left {
    return self.frame.origin.x;
}

- (void)setEs_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)es_top {
    return self.frame.origin.y;
}

- (void)setEs_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)es_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setEs_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)es_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setEs_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)es_width {
    return self.frame.size.width;
}

- (void)setEs_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)es_height {
    return self.frame.size.height;
}

- (void)setEs_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)es_centerX {
    return self.center.x;
}

- (void)setEs_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)es_centerY {
    return self.center.y;
}

- (void)setEs_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)es_origin {
    return self.frame.origin;
}

- (void)setEs_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)es_size {
    return self.frame.size;
}

- (void)setEs_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
