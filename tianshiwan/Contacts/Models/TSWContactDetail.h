//
//  TSWContactDetail.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define CONTACT_DETAIL @"v1/member"
@interface TSWContactDetail : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *project;
@property (nonatomic, strong) NSString *companyFullName;
@property (nonatomic, strong) NSString *companyCityName;
@property (nonatomic, strong) NSString *companyAddress;
@property (nonatomic, strong) NSString *imgUrl_2x;
@property (nonatomic, strong) NSString *imgUrl_3x;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *wechat;

@end
