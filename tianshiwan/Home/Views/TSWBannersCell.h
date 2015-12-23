//
//  TSWBannersCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCycleScrollView.h"
#import "TSWBanner.h"

@class TSWBanner;

@protocol TSWBannersCellDelegate;

@interface TSWBannersCell : UICollectionViewCell

@property (nonatomic, weak) id <TSWBannersCellDelegate> delegate;

@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, strong) CXCycleScrollView *cycleScrollView;


@end

@protocol TSWBannersCellDelegate <NSObject>

- (void) gotoDetail:(TSWBannersCell *)cell withBanner:(TSWBanner *)banner;

@end
