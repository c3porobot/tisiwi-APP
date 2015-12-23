//
//  TSWFinanceDetail.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define FINANCE_DETAIL @"v1/service/financing"
@interface TSWFinanceDetail : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, assign) NSInteger like;
@property (nonatomic, strong) NSString *rounds;
@property (nonatomic, strong) NSString *fields;
@property (nonatomic, strong) NSString *cases;
@property (nonatomic, strong) NSString *applyMethod;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *card;
@property (nonatomic, assign) NSInteger hasAttachment;
@property (nonatomic, strong) NSString *referrer;
@property (nonatomic, strong) NSString *email; //邮箱

@end
