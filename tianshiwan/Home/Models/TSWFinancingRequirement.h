//
//  TSWFinancingRequirement.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define FINANCE_DETAIL @"v1/requirement/financing/"
@interface TSWFinancingRequirement : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *valuation;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *amountType;
@property (nonatomic, assign) NSInteger fa;
@property (nonatomic, strong) NSString *projectStatus;



@end
