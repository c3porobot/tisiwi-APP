//
//  TSWFinanceList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
//#define FINANCE_LIST @"v1/service/financing"
#define FINANCE_LIST @"v1/service/financing/member/"
@interface TSWFinanceList : CXResource
@property (nonatomic, strong) NSMutableArray *finances;
@property (nonatomic, assign) NSInteger page;
@end
