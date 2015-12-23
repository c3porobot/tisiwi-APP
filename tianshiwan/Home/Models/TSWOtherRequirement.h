//
//  TSWOtherRequirement.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define OTHER_DETAIL @"v1/requirement/other/"
@interface TSWOtherRequirement : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *requirementType;
@property (nonatomic, strong) NSString *requirementDesc;

@end
