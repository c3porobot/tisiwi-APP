//
//  TSWBanner.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWBanner : CXResource

@property (nonatomic, strong) NSString *article;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *imgUrl_2x;
@property (nonatomic, strong) NSString *imgUrl_3x;

@end
