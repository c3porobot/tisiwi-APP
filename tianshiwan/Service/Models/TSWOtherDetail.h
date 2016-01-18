//
//  TSWOtherDetail.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define OTHER_DETAIL @"v1/service/other"
@interface TSWOtherDetail : CXResource
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *companyIntroduction;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, strong) NSString *applyMethod;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, assign) NSInteger hasAttachment;
@property (nonatomic, strong) NSString *referrer;
@property (nonatomic ,copy) NSString *email;// 邮箱
@property (nonatomic, copy) NSString *served_aera; //服务地区
@property (nonatomic, copy) NSString *tags; //标签
@property (nonatomic, copy) NSString *cases;
@end
