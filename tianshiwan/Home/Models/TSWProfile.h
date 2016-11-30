//
//  TSWProfile.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define PROFILE @"v1/profile"
@interface TSWProfile : CXResource

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *companyAddress;
@property (nonatomic, strong) NSString *companyCityCode;
@property (nonatomic, strong) NSString *companyCityName;
@property (nonatomic, strong) NSString *companyFullName;
@property (nonatomic, strong) NSString *imgUrl_2x;
@property (nonatomic, strong) NSString *imgUrl_3x;
@property (nonatomic, strong) NSString *projectName; //项目名称
@property (nonatomic, strong) NSString *projectSummary; //项目介绍
@property (nonatomic, strong) NSString *unviewnum; //未读消息数
@end
