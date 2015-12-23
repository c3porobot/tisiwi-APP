//
//  TSWBannersCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWBannersCell.h"

#import "CXCycleScrollView.h"

#import "TSWBanner.h"

@interface TSWBannersCell () <CXCycleScrollViewDelegate>


@end

@implementation TSWBannersCell
//初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        _cycleScrollView = [[CXCycleScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        _cycleScrollView.showDot = YES;   //是否显示分页控制器
        _cycleScrollView.delegate = self; //设置代理
        [self.contentView addSubview:_cycleScrollView];
    }
    
    return self;
}
//布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    _cycleScrollView.frame = CGRectMake(0.0F, 0.0F, width, height);
}

- (void)setBanners:(NSArray *)banners
{
    _banners = banners;
    
    if ([self.banners count] == 1) {
        TSWBanner *banner = self.banners[0];
        self.cycleScrollView.imageURLArray = @[banner.imgUrl_3x];
    }else if ([self.banners count] > 1) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (TSWBanner *banner in self.banners) {
            [array addObject:banner.imgUrl_3x];
        }
        self.cycleScrollView.imageURLArray = array;
    }
    else {
        self.cycleScrollView.imageURLArray = @[];
    }
    _cycleScrollView.showDot = YES;
    
    [self setNeedsLayout];
}




//轮播图
#pragma mark CXCycleScrollViewDelegate
- (void)cycleScrollView:(CXCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    if ([self.banners count] >= index) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gotoDetail:withBanner:)]) {
            if(index > 0){
                [self.delegate gotoDetail:self withBanner:_banners[index-1]];
            }else if(index == 0){
                [self.delegate gotoDetail:self withBanner:_banners[index]];
            }
        }
    }
}

@end
