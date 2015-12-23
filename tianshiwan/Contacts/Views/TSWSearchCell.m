//
//  TSWSearchCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/15.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWSearchCell.h"

@interface TSWSearchCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation TSWSearchCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *searchBoxView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*15.0f, 28.0f)];
        searchBoxView.backgroundColor = [UIColor whiteColor];
        searchBoxView.layer.cornerRadius = 14.0f;
        searchBoxView.layer.borderWidth = 1;
        searchBoxView.layer.borderColor = [RGB(226, 226, 226) CGColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 21.0f, 21.0f)];
        self.imageView.image = [UIImage imageNamed:@"search"];
        self.imageView.backgroundColor = [UIColor whiteColor];
        [searchBoxView addSubview:self.imageView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f+21.0f+5.0f, 3.0f, width-2*31.0f, 28.0f)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.placeholder = @"搜索姓名、职位、公司、项目";
        _textField.autocapitalizationType = NO;
        [searchBoxView addSubview:_textField];
        
        [self.contentView addSubview:searchBoxView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
