//
//  TSWClearReusableView.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWClearReusableView.h"

@interface TSWClearReusableView ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation TSWClearReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 0.0f, width, 0.5f)];
        _topLineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];;
        //        [self addSubview:_topLineView];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, height - 0.5f, width, 0.5f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];;
        [self addSubview:_bottomLineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    _topLineView.frame = CGRectMake(0.0F, 0.0f, width, 0.5f);
    _bottomLineView.frame = CGRectMake(0.0F, height - 0.5f, width, 0.5f);
}


@end