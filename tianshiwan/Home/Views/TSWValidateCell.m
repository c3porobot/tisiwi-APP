//
//  TSWValidateCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWValidateCell.h"
#import "TSWValidate.h"
#import "TSWCheckPhoneExist.h"
#import "TSWSendLoginVeriCode.h"

static const CGFloat KTSWValidateCellDy = 10.0f;

static const CGFloat KTSWValidateCellButtonWidth = 70.0f;

@interface TSWValidateCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *timeButton;

@end

@implementation TSWValidateCell

- (void)dealloc
{
    [_validate removeObserver:self forKeyPath:@"surplusTime"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.contentView.bounds);
        CGFloat height = CGRectGetHeight(self.contentView.bounds);
        
        self.bodyView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, KTSWValidateCellDy, width, height - 2 * KTSWValidateCellDy)];
        
        self.bodyView.backgroundColor = [UIColor whiteColor];
        self.bodyView.layer.borderWidth = 0.5f;
        self.bodyView.layer.borderColor = [RGB(221, 221, 221) CGColor];
        self.bodyView.layer.cornerRadius = 2.0f;
        
        [self.contentView addSubview:self.bodyView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f, 0.0f, width - KTSWValidateCellButtonWidth - 0.5f - 10.0f, CGRectGetHeight(self.bodyView.bounds))];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.delegate = self;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.autocapitalizationType = NO;
        [self.bodyView addSubview:_textField];
        
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(width - KTSWValidateCellButtonWidth - 0.5f, 0.0f, 0.5, CGRectGetHeight(self.bodyView.bounds))];
        self.lineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];;
        [self.bodyView addSubview:self.lineView];
        
        self.timeButton = [[UIButton alloc] initWithFrame:CGRectMake(width - KTSWValidateCellButtonWidth, 0.0f, KTSWValidateCellButtonWidth, CGRectGetHeight(self.bodyView.bounds))];
        self.timeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_timeButton setTitle:@"校验" forState:UIControlStateNormal];
        [self.timeButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bodyView addSubview:self.timeButton];
    }
    return self;
}

- (void)setValidate:(TSWValidate *)validate
{
    _validate = validate;
    
    if (!self.validate.isStartTime) {
//        [self.validate startTime];
    }
    else {
        if (self.validate.surplusTime <= 0) {
            [_timeButton setTitle:@"重发" forState:UIControlStateNormal];
            [self.timeButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            _timeButton.userInteractionEnabled = YES;
            
        }
    }
    
    [self.validate addObserver:self
                        forKeyPath:@"surplusTime"
                           options:NSKeyValueObservingOptionNew
                           context:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    CGFloat height = CGRectGetHeight(self.contentView.bounds);
    
    self.bodyView.frame = CGRectMake(0.0f, KTSWValidateCellDy, width, height - 2 * KTSWValidateCellDy);
    
    _textField.frame = CGRectMake(5.0f, 0.0f, width - KTSWValidateCellButtonWidth - 0.5f - 10.0f, CGRectGetHeight(self.bodyView.bounds));
    
    
    self.lineView.frame = CGRectMake(width - KTSWValidateCellButtonWidth - 0.5f, 0.0f, 0.5, CGRectGetHeight(self.bodyView.bounds));
    
    self.timeButton.frame = CGRectMake(width - KTSWValidateCellButtonWidth, 0.0f, KTSWValidateCellButtonWidth, CGRectGetHeight(self.bodyView.bounds));
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"surplusTime"]) {
        if (object == _validate) {
            if (_validate.surplusTime > 0) {
                int seconds = self.validate.surplusTime % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                
                [_timeButton setTitle:[NSString stringWithFormat:@"重发(%@)",strTime] forState:UIControlStateNormal];
                [self.timeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _timeButton.userInteractionEnabled = NO;
                [_timeButton setEnabled:NO];
            }
            else {
                [_timeButton setTitle:@"重发" forState:UIControlStateNormal];
                [self.timeButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
                _timeButton.userInteractionEnabled = YES;
                [_timeButton setEnabled:YES];
            }
        }
    }
}

+ (CGSize)calculateCellSizeWithValidateCode:(TSWValidate *)validate containerWidth:(CGFloat)containerWidth
{
    return CGSizeMake(containerWidth, 65.0f);
}

#pragma mark Button Response
- (void)clickAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendValidateCell:)]) {
        [self.delegate sendValidateCell:self];
    }
}

#pragma mark- UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.validate.code = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(validateCell:validate:)]) {
        [self.delegate validateCell:self validate:self.validate];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.validate.code = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(validateCell:validate:)]) {
        [self.delegate validateCell:self validate:self.validate];
    }
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    
    self.validate.code = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(validateCell:validate:)]) {
        [self.delegate validateCell:self validate:self.validate];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    self.validate.code = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(validateCell:validate:textField:)]) {
        [self.delegate validateCell:self validate:self.validate textField:textField];
    }
    
    return YES;
}

@end

