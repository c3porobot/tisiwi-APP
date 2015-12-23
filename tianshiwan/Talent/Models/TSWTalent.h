//
//  TSWTalent.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWTalent : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *seniority;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, strong) NSString *titles;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, assign) NSInteger hasAttachment;

@end
