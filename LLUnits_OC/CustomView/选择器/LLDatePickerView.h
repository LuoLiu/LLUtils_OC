//
//  LLDatePickerView.h
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLDatePickerViewDelegate <NSObject>

- (void)didSelectDate:(NSDate *)date;

@end

@interface LLDatePickerView : UIView

@property (nonatomic, weak) id<LLDatePickerViewDelegate> delegate;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end


