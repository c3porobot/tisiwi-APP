//
//  TSWLineCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/19.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWLineCell.h"

@implementation TSWLineCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, width-20.0f, 0.5f)];
        lineView.backgroundColor = RGB(206, 206, 206);
        lineView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


+ (CGSize)calculateCellSizeWithSummary:(CGFloat)containerWidth
{
    return CGSizeMake(containerWidth, 20.5f);
}


@end

