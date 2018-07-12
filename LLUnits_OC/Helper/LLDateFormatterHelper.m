//
//  LLDateFormatterHelper.m
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "LLDateFormatterHelper.h"

@implementation LLDateFormatterHelper

// format: yyyy-MM-dd
+ (NSString *)yyyyMMddStringFromDate:(NSDate *)date {
    static dispatch_once_t onceOutput;
    static NSDateFormatter *outputDateFormatter;
    dispatch_once(&onceOutput, ^{
        outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [outputDateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return [outputDateFormatter stringFromDate:date];
}

// format: yyyy年MM月dd日
+ (NSString *)calendarStringFromDate:(NSDate *)date {
    static dispatch_once_t onceOutput;
    static NSDateFormatter *outputDateFormatter;
    dispatch_once(&onceOutput, ^{
        outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [outputDateFormatter setDateFormat:@"yyyy年MM月dd日"];
    });
    return [outputDateFormatter stringFromDate:date];
}

// 计算两个日期之间的天数
+ (NSInteger)calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeInterval time = [endDate timeIntervalSinceDate:beginDate];
    int days = ((int)time) / (3600*24);
    
    return days;
}

// 获取当前月的天数
+ (NSInteger)getSumOfDaysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    return range.length;
}

// 获取给定日期的月份
+ (NSInteger)getMonthOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    return [components month];
}

// 获取给定日期的号数
+ (NSInteger)getDayOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    return [components day];
}

@end
