//
//  TSWServiceList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define SERVICE_LIST @"v1/service"

@interface TSWServiceList : CXResource
@property (nonatomic, strong) NSMutableArray *services;
@end
