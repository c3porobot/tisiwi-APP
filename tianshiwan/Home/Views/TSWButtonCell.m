//
//  TSWButtonCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWButtonCell.h"

#import "TSWButtonInfo.h"

#import "UIImage+CXExtensions.h"
#import "UIColor+CXExtensions.h"

@interface TSWButtonCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation TSWButtonCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, height - 44.0f, width, 44.0f)];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)dealloc
{
    [_buttonInfo removeObserver:self forKeyPath:@"isCanClick"];
}

- (void)setButtonInfo:(TSWButtonInfo *)buttonInfo
{
    if (_buttonInfo) {
        [_buttonInfo removeObserver:self forKeyPath:@"isCanClick"];
    }
    
    _buttonInfo = buttonInfo;
    
    [self.buttonInfo addObserver:self
                      forKeyPath:@"isCanClick"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    
    [self.button setTitle:self.buttonInfo.title forState:UIControlStateNormal];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    self.button.frame = CGRectMake(0.0f, height - 44.0f, width, 44.0f);
    
    
    UIColor *color = nil;
    
    if (self.buttonInfo) {
        color = self.buttonInfo.isCanClick ? self.buttonInfo.color : self.buttonInfo.unclickColor;
    }
    
    UIImage *image = nil;
    UIImage *highlightedImage = nil;
    if (color) {
        image = [UIImage cx_imageWithSize:self.button.bounds.size color:color cornerRadius:4.0f];
        highlightedImage = [UIImage cx_imageWithSize:self.button.bounds.size color:[color cx_colorByDarkeningColorWithValue:0.12f] cornerRadius:4.0f];
    }
    
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    [self.button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"isCanClick"]) {
        if (object == _buttonInfo) {
            [self setNeedsLayout];
        }
    }
}

#pragma mark Button Response
- (void)clickAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonCell:buttonInfo:)]) {
        [self.delegate buttonCell:self buttonInfo:self.buttonInfo];
    }
}

+ (CGSize)calculateCellSizeWithCategoryChild:(NSNumber *)categoryChild containerWidth:(CGFloat)containerWidth
{
    return CGSizeMake(containerWidth, 58.0f);
}

@end
