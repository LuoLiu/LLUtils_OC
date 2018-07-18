//
//  NSArray+Enum.m
//  LLUnits_OC
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "NSArray+Enum.h"

@implementation NSArray (Enum)

- (NSString *)stringWithEnum:(NSUInteger)enumVal {
    return [self objectAtIndex:enumVal];
}

- (NSUInteger)enumFromString:(NSString*)strVal default:(NSUInteger)def {
    NSUInteger n = [self indexOfObject:strVal];
    if (n == NSNotFound) {
        n = def;
    }
    return n;
}

- (NSUInteger)enumFromString:(NSString*)strVal {
    return [self enumFromString:strVal default:0];
}

@end
