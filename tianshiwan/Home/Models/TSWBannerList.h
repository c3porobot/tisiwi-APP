//
//  TSWBannerList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define BANNER_LIST @"v1/banner"

@interface TSWBannerList : CXResource

@property (nonatomic, strong) NSMutableArray *banners;

@end
