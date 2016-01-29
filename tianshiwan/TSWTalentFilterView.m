//
//  TSWTalentFilterView.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/27.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWTalentFilterView.h"

@implementation TSWTalentFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.expirceLabel];
        [self addSubview:self.expTextField];
        [self addSubview:self.yearLabel];
        [self addSubview:self.salaryLabel];
        [self addSubview:self.salaryTextField];
        [self addSubview:self.KLabel];
        [self addSubview:self.resettingBtn];
        [self addSubview:self.completeBtn];
    }
    return self;
}

- (UILabel *)expirceLabel {
    if (!_expirceLabel) {
        self.expirceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 30)];
        self.expirceLabel.text = @"工作经验";
        self.expirceLabel.textColor = RGB(127, 127, 127);
    }
    return _expirceLabel;
}
//- (void)layoutExpriceLabel {
//    self.expirceLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 30)];
//    self.expirceLabel.text = @"工作经验";
//    self.expirceLabel.textColor = RGB(127, 127, 127);
//    [self addSubview:_expirceLabel];
//}
- (UITextField *)expTextField {
    if (!_expTextField) {
        self.expTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.expirceLabel.frame), CGRectGetMinY(self.expirceLabel.frame), 150, CGRectGetHeight(self.expirceLabel.frame))];
        self.expTextField.layer.masksToBounds = YES;
        self.expTextField.layer.cornerRadius = 5;
        self.expTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _expTextField;
}
- (UILabel *)yearLabel {
    if (!_yearLabel) {
        self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.expTextField.frame) + 30, CGRectGetMinY(self.expirceLabel.frame), 50, CGRectGetHeight(self.expirceLabel.frame))];
        self.yearLabel.text = @"年";
        self.yearLabel.textColor = RGB(127, 127, 127);
    }
    return _yearLabel;
}

- (UILabel *)salaryLabel {
    if (!_salaryLabel) {
        self.salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.expirceLabel.frame), CGRectGetMaxY(self.expirceLabel.frame) + 10, CGRectGetWidth(self.expirceLabel.frame), CGRectGetHeight(self.expirceLabel.frame))];
        self.salaryLabel.text = @"薪资要求";
        self.salaryLabel.textColor = RGB(127, 127, 127);

    }
    return _salaryLabel;
}

- (UITextField *)salaryTextField {
    if (!_salaryTextField) {
        self.salaryTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.salaryLabel.frame), CGRectGetMinY(self.salaryLabel.frame), CGRectGetWidth(self.expTextField.frame), CGRectGetHeight(self.expTextField.frame))];
        self.salaryTextField.layer.masksToBounds = YES;
        self.salaryTextField.layer.cornerRadius = 5;
        self.salaryTextField.borderStyle = UITextBorderStyleRoundedRect;

    }
    return _salaryTextField;
}

- (UILabel *)KLabel {
    if (!_KLabel) {
        self.KLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.salaryTextField.frame) + 30, CGRectGetMinY(self.salaryTextField.frame), CGRectGetWidth(self.yearLabel.frame), CGRectGetHeight(self.yearLabel.frame))];
        self.KLabel.text = @"K";
        self.KLabel.textColor = RGB(127, 127, 127);
    }
    return _KLabel;
}

- (UIButton *)resettingBtn {
    if (!_resettingBtn) {
        self.resettingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.resettingBtn.frame = CGRectMake(30, CGRectGetMaxY(self.salaryLabel.frame) + 50, 100, 30);
        [self.resettingBtn setTitle:@"重 置" forState:UIControlStateNormal];
        self.tintColor = RGB(127, 127, 127);

        [self.resettingBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        
        [self.resettingBtn.layer setCornerRadius:10];
        
        [self.resettingBtn.layer setBorderWidth:1];//设置边界的宽度
        
        //设置按钮的边界颜色
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        //{r, g, b, alpha}
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){127/255.0,127/255.0,127/255.0,1});
        
        [self.resettingBtn.layer setBorderColor:color];
    }
    return _resettingBtn;
}

- (UIButton *)completeBtn {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (!_completeBtn) {
        self.completeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        self.completeBtn.frame = CGRectMake(width / 2 + CGRectGetWidth(self.resettingBtn.frame) / 2, CGRectGetMinY(self.resettingBtn.frame), 100, 30);
        [self.completeBtn setTitle:@"完 成" forState:UIControlStateNormal];
        self.tintColor = RGB(127, 127, 127);
        
        [self.completeBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        
        [self.completeBtn.layer setCornerRadius:10];
        
        [self.completeBtn.layer setBorderWidth:1];//设置边界的宽度
        
        //设置按钮的边界颜色
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        //{r, g, b, alpha}
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){127/255.0,127/255.0,127/255.0,1});
        
        [self.completeBtn.layer setBorderColor:color];
    }
    return _completeBtn;
}
@end
