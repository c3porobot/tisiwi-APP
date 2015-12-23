//
//  TSWAdvertisement.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWAdvertisement : CXResource

@property (nonatomic, copy) NSString *bannerUrl;
@property (nonatomic, copy) NSString *jumpUrl;
@property (nonatomic, copy) NSString *logon;
@property (nonatomic, assign) NSInteger position;

@end
