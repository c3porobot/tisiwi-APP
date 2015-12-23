//
//  TSWTextFieldCellCollectionViewCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTextFieldCell.h"

#import "TSWTextField.h"

#import "TSWTextInput.h"

@interface TSWTextFieldCell () <TSWTextFieldDelegate>



@end

@implementation TSWTextFieldCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        self.textField = [[TSWTextField alloc] initWithFrame:CGRectMake(0.0f, height - 44.0f, width, 44.0f)];
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        self.textField.delegate = self;
        [_textField becomeFirstResponder];
        
        [self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.textField.frame = CGRectMake(0.0f, height - 44.0f, width, 44.0f);
}

- (void)setTextInput:(TSWTextInput *)textInput
{
    _textInput = textInput;
    
    self.textField.textInput = self.textInput;
}

+ (CGSize)calculateCellSizeWithCategoryChild:(NSNumber *)categoryChild containerWidth:(CGFloat)containerWidth
{
    if ([categoryChild integerValue] < 0) {
        return CGSizeMake(containerWidth, 44.0f);
    }
    else {
        return CGSizeMake(containerWidth, 56.0f);
    }
}

#pragma mark- TSWTextFieldDelegate Method

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
    self.textInput.text = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldCell:textInput:)]) {
        [self.delegate textFieldCell:self textInput:self.textInput];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    self.textInput.text = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldCell:textInput:)]) {
        [self.delegate textFieldCell:self textInput:self.textInput];
    }
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.textInput.text = textField.text;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldCell:textInput:)]) {
        [self.delegate textFieldCell:self textInput:self.textInput];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    self.textInput.text = textField.text;
    [textField resignFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldCell:textInput:textField:)]) {
        [self.delegate textFieldCell:self textInput:self.textInput textField:textField];
    }
    
    return YES;
}

@end
