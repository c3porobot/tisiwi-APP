//
//  TSWResultList.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/2.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define RESULT_LIST @"v1/search_service"
@interface TSWResultList : CXResource

@property (nonatomic, strong) NSMutableArray *results;
@end
