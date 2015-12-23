//
//  TSWTextField.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTextField.h"

#import "TSWTextInput.h"

@interface TSWTextField () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;

@end

@implementation TSWTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bgImageView.userInteractionEnabled = YES;
        [self addSubview:_bgImageView];
        
        _textField = [[UITextField alloc] initWithFrame:_bgImageView.bounds];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.delegate = self;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.autocapitalizationType = NO;
        [_bgImageView addSubview:_textField];
    }
    
    return self;
}

- (void)setTextInput:(TSWTextInput *)textInput
{
    _textInput = textInput;
    
    _textField.keyboardType = self.textInput.keyboardType;
    _textField.returnKeyType = self.textInput.returnKeyType;
    _textField.secureTextEntry = self.textInput.secureTextEntry;
    _textField.placeholder = self.textInput.placeholder;
    
    if (UIEdgeInsetsEqualToEdgeInsets(self.textInput.capInsets, UIEdgeInsetsZero)) {
        _bgImageView.image = [UIImage imageNamed:self.textInput.imageName];
        _bgImageView.highlightedImage = [UIImage imageNamed:self.textInput.highlightedImageName];
    }
    else {
        _bgImageView.image = [[UIImage imageNamed:self.textInput.imageName] resizableImageWithCapInsets:self.textInput.capInsets resizingMode:UIImageResizingModeStretch];
        _bgImageView.highlightedImage = [[UIImage imageNamed:self.textInput.highlightedImageName]  resizableImageWithCapInsets:self.textInput.capInsets resizingMode:UIImageResizingModeStretch];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _bgImageView.frame = self.bounds;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    _textField.frame = CGRectMake(self.textInput.capInsets.left, 0.0F, width - self.textInput.capInsets.left - self.textInput.capInsets.right, height);
}

#pragma mark- UITextFieldDelegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.bgImageView.highlighted = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.delegate textFieldShouldBeginEditing:textField];
    }
    else {
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.delegate textFieldShouldEndEditing:textField];
    }
    else {
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length == 0) {
        self.bgImageView.highlighted = NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    textField.text = @"";
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [self.delegate textFieldShouldClear:textField];
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField.text.length == 0) {
        self.bgImageView.highlighted = NO;
    }
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        [textField nextResponder];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.delegate textFieldShouldReturn:textField];
    }
    else {
        return YES;
    }
}

@end
