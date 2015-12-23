//
//  TSWServiceSearchCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWServiceSearchCell.h"

@interface TSWServiceSearchCell()
@property (nonatomic, strong) UIView *searchBoxView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation TSWServiceSearchCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        self.contentView.backgroundColor = [UIColor whiteColor];
        _searchBoxView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*15.0f, 28.0f)];
        _searchBoxView.backgroundColor = [UIColor whiteColor];
        _searchBoxView.layer.cornerRadius = 14.0f;
        _searchBoxView.layer.borderWidth = 0.5f;
        _searchBoxView.layer.borderColor = [RGB(226, 226, 226) CGColor];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 21.0f, 21.0f)];
        self.imageView.image = [UIImage imageNamed:@"search"];
        self.imageView.backgroundColor = [UIColor whiteColor];
        [_searchBoxView addSubview:self.imageView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-2*31.0f, 28.0f)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.backgroundColor = [UIColor clearColor];
        _textField.autocapitalizationType = NO;
        [_textField addTarget:self action:@selector(searchBegin) forControlEvents: UIControlEventEditingDidBegin];
        [_searchBoxView addSubview:_textField];
        
        self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 60.0f, 0.0f, 60.0f, 48.0f)];
        self.cancelBtn.backgroundColor = [UIColor clearColor];
        [self.cancelBtn setTitleColor:RGB(32, 158, 217) forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        self.cancelBtn.hidden = YES;
        
        [self.contentView addSubview:_searchBoxView];
        [self.contentView addSubview:self.cancelBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)searchBegin{
    self.contentView.backgroundColor = RGB(234, 234, 234);
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    self.searchBoxView.frame = CGRectMake(15.0f, 10.0f, width-15.0f - 60.0f, 28.0f);
    self.textField.frame = CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-31.0f - 60.0f, 28.0f);
    [UIView commitAnimations];
    
}

-(void)didStopAnimation{
    self.cancelBtn.hidden = NO;
}

-(void)cancel{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.contentView.bounds);
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation2)];
    self.searchBoxView.frame = CGRectMake(15.0f, 10.0f, width-2*15.0f, 28.0f);
    self.textField.frame = CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-2*31.0f, 28.0f);
    [UIView commitAnimations];
    self.cancelBtn.hidden = YES;
    // 清空
    _textField.text = @"";
    // 使失去焦点
    [_textField resignFirstResponder];
}

-(void)didStopAnimation2{
    
}


@end
