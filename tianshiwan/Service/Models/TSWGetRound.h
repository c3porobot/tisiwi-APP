//
//  TSWGetRound.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define GET_ROUND @"v1/financing_service_round"
@interface TSWGetRound : CXResource
@property (nonatomic, strong) NSMutableArray *rounds;
@end
