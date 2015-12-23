//
//  CXNavigationBar.m
//
//  Created by 熊财兴 on 15/1/13.
//  Copyright (c) 2015年 熊财兴. All rights reserved.
//

#import "CXNavigationBar.h"

static const CGFloat kCXNavigationBarButtonMaxWidth = 86.0f; // 左右按钮最大宽度

@interface CXNavigationBar ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation CXNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    if (_titleView && [_titleView isKindOfClass:[UILabel class]]) {
        ((UILabel*)_titleView).text = self.title;
    }
}

- (void)setTitleView:(UILabel *)titleView
{
    _titleView = titleView;
    
    [self.backgroundView addSubview:self.titleView];
}

- (void)setLeftButton:(UIButton *)leftButton
{
    _leftButton = leftButton;
    
    [self addSubview:self.leftButton];
}

- (void)setRightButton:(UIButton *)rightButton
{
    _rightButton = rightButton;
    
    [self addSubview:self.rightButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat startY = 0.0F;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        startY = 20.0f;
    }
    
    if (_backgroundView) {
        _backgroundView.frame = self.bounds;
    }
    
    if (_bottomLineView) {
        _bottomLineView.frame = CGRectMake(0.0f, height - 0.5F, width, 0.5F);
    }
    
    if (_leftButton) {
        _leftButton.frame = CGRectMake(0.0f, startY, (CGRectGetWidth(_leftButton.bounds) <=  kCXNavigationBarButtonMaxWidth) ? CGRectGetWidth(_leftButton.bounds) : kCXNavigationBarButtonMaxWidth, height - startY);
    }
    
    if (_rightButton) {
        CGFloat rightButtonX = CGRectGetMinX(_rightButton.frame);
        
        CGFloat rightButtonWidth = (CGRectGetWidth(_rightButton.bounds) <=  kCXNavigationBarButtonMaxWidth) ? CGRectGetWidth(_rightButton.bounds) : kCXNavigationBarButtonMaxWidth;
        
        if ((width - kCXNavigationBarButtonMaxWidth) > CGRectGetMinX(_rightButton.frame)) {
            rightButtonX = width - kCXNavigationBarButtonMaxWidth;
        }
        
        CGFloat rightButtonHeight = ((height - startY) > CGRectGetHeight(_rightButton.bounds)) ? CGRectGetHeight(_rightButton.bounds) : (height - startY);
        _rightButton.frame = CGRectMake(rightButtonX, startY + (height - startY - rightButtonHeight) / 2.0F, rightButtonWidth, rightButtonHeight);
    }
    
    CGFloat titleViewHeight = height - startY;
    CGFloat titleViewWidth = 0.0f;
    CGFloat titleViewStarX = 0.0f;
    if (CGRectGetHeight(_titleView.frame) < (height - startY)) {
        titleViewHeight = CGRectGetHeight(_titleView.frame);
    }
    
    
    if (_leftButton && !_rightButton) {
        titleViewStarX = CGRectGetMaxX(_leftButton.frame);
        titleViewWidth = width - 2 * titleViewStarX;
    }
    else if (!_leftButton && _rightButton) {
        titleViewStarX = width - CGRectGetMinX(_rightButton.frame);
        titleViewWidth = width - 2 * titleViewStarX;
    }
    else if (!_leftButton && !_rightButton) {
        titleViewStarX = 0.0f;
        titleViewWidth = width;
    }
    else if (_leftButton && _rightButton) {
        if (CGRectGetMaxX(_leftButton.frame) >= (width - CGRectGetMinX(_rightButton.frame))) {
            titleViewStarX = CGRectGetMaxX(_leftButton.frame);
        }
        else {
            titleViewStarX = width - CGRectGetMinX(_rightButton.frame);
        }
        titleViewWidth = width - 2 * titleViewStarX;
    }
    
    _titleView.frame = CGRectMake(titleViewStarX + 5.0f, startY + (height - startY - titleViewHeight) / 2.0f, titleViewWidth - 10.0f, titleViewHeight);
}

#pragma mark Private
- (void)setup
{
    if (!_backgroundView) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
     //   view.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:84.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
      //  view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarBack"]];
        view.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];

        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundView = view;
    }
    [self addSubview:self.backgroundView];
    
    if (!_bottomLineView) {
        UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(self.bounds) - 0.5F, CGRectGetWidth(self.bounds), 0.5F)];
        view.backgroundColor = [UIColor colorWithRed:188.0f/255.0f green:188.0f/255.0f blue:188.0f/255.0f alpha:1.0f];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.bottomLineView = view;
    }
    // 1.1.0版本去掉了该线条
//    [self.backgroundView addSubview:self.bottomLineView];
    
    if (!_titleView) {
        CGRect labelFrame = CGRectMake(0.0F, 0.0F, CGRectGetWidth(self.backgroundView.bounds), CGRectGetHeight(self.backgroundView.bounds));
        
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        
        if (_title) {
            label.text = _title;
        }
        
        self.titleView = label;
    }
}

@end
