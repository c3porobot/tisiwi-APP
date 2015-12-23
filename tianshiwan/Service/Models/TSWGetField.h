//
//  TSWGetField.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define GET_FIELD @"v1/financing_service_field"
@interface TSWGetField : CXResource
@property (nonatomic, strong) NSMutableArray *fields;
@end
