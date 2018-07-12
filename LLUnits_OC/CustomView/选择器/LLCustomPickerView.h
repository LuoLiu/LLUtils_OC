//
//  LLCustomPickerView.h
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLCustomPickerViewDelegate <NSObject>

- (void)didSelectRowIndex:(NSInteger)index;

@end

@interface LLCustomPickerView : UIView

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) id<LLCustomPickerViewDelegate> delegate;

- (instancetype)initWithStringArray:(NSArray *)array;

@end
