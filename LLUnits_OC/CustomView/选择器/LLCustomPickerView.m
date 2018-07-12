//
//  LLCustomPickerView.m
//  LLUnits_OC
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 luoliu. All rights reserved.
//

#import "LLCustomPickerView.h"

static const NSInteger kPickerViewHeight = 235;
static const NSInteger kToolBarHeight = 44;

@interface LLCustomPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, copy) NSArray<NSString *> *stringArray;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation LLCustomPickerView

- (instancetype)initWithStringArray:(NSArray *)array {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
        [self addGestureRecognizer:tap];
        [self addSubview:self.containerView];
        
        [self.containerView addSubview:self.pickerView];
        [self.containerView addSubview:self.confirmButton];
        [self.containerView addSubview:self.cancelButton];
        self.stringArray = [NSArray arrayWithArray:array];
    }
    return self;
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.stringArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.stringArray[row];
}

#pragma mark - UIPickerView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
}

#pragma mark - getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc]initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - kPickerViewHeight, UIScreen.mainScreen.bounds.size.width, kPickerViewHeight)];
        _containerView.backgroundColor = [UIColor blueColor];
    }
    return _containerView;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-70, 0, 60, 44)];
        _confirmButton.backgroundColor = UIColor.clearColor;
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 60, 44)];
        _cancelButton.backgroundColor = UIColor.clearColor;
        _cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}


- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kToolBarHeight, UIScreen.mainScreen.bounds.size.width, kPickerViewHeight - kToolBarHeight)];
        _pickerView.backgroundColor = UIColor.whiteColor;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}


#pragma mark - event response

- (void)confirm:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(didSelectRowIndex:)]) {
        [self.delegate didSelectRowIndex:self.selectedRow];
    }
    [self removeFromSuperview];
}

- (void)dismissView {
    [self removeFromSuperview];
}

- (void)cancel:(UIButton *)button {
    [self dismissView];
}

@end
