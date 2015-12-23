//
//  TSWGetPosition.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define GET_POSITION @"v1/personnel_service_title"
@interface TSWGetPosition : CXResource
@property (nonatomic, strong) NSMutableArray *positions;
@end
