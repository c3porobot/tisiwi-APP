//
//  TSWOtherList.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define OTHER_LIST @"v1/service/"
@interface TSWOtherList : CXResource
@property (nonatomic, strong) NSMutableArray *others;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isInfinite;
@end
