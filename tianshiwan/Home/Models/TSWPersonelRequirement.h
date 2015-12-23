//
//  TSWPersonelRequirement.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define PERSONNEL_DETAIL @"v1/requirement/personnel/"
@interface TSWPersonelRequirement : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, strong) NSString *hr;
@property (nonatomic, strong) NSString *hrEmail;
@property (nonatomic, strong) NSString *responsibility;
@property (nonatomic, strong) NSString *requirements;

@end
