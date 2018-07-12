//
//  LLDateFormatterHelper.h
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDateFormatterHelper : NSObject

// format: yyyy-MM-dd
+ (NSString *)yyyyMMddStringFromDate:(NSDate *)date;

// format: yyyy年MM月dd日
+ (NSString *)calendarStringFromDate:(NSDate *)date;

// 计算两个日期之间的天数
+ (NSInteger)calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;

// 获取当前月的天数
+ (NSInteger)getSumOfDaysInMonth;

// 获取给定日期的月份
+ (NSInteger)getMonthOfDate:(NSDate *)date;

// 获取给定日期的号数
+ (NSInteger)getDayOfDate:(NSDate *)date;

@end
