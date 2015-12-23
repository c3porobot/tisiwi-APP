//
//  TSWMyRootCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWMyRootCell.h"

static const CGFloat kTSWMyRootCellLeft = 20.0f; // 距离左边距离
static const CGFloat kTSWMyRootCellRight = 12.0f; // 距离右边距离

@interface TSWMyRootCell ()

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIImageView *arrowImageView;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation TSWMyRootCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = RGB(97, 97, 97);
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.textLabel];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, height - 0.5f, width, 0.5f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];;
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    _textLabel.frame = CGRectMake(kTSWMyRootCellLeft, 0.0f, width - kTSWMyRootCellRight - 13.0f - kTSWMyRootCellLeft, height);
    
    _bottomLineView.frame = CGRectMake(0.0F, height - 0.5f, width, 0.5f);
}

- (void)setContentDic:(NSDictionary *)contentDic
{
    _contentDic = contentDic;
    
    self.textLabel.text = self.contentDic[@"text"];
}


+ (CGSize)calculateCellSizeWithCategoryChild:(NSNumber *)categoryChild containerWidth:(CGFloat)containerWidth
{
    return CGSizeMake(containerWidth, 42.0f);
}

@end

