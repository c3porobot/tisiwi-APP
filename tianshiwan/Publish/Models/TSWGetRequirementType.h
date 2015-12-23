//
//  TSWGetRequirementType.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define GET_TYPE @"v1/other_requirement_type"
@interface TSWGetRequirementType : CXResource
@property (nonatomic, strong) NSMutableArray *types;
@end
