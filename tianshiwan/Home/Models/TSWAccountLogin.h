//
//  TSWAccountLogin.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

#define ACCOUNT_LOGIN @"v1/login"

@interface TSWAccountLogin : CXResource

@property (nonatomic, copy) NSString *token;        //令牌
@property (nonatomic, copy) NSString *refreshToken; //更新令牌
@property (nonatomic, copy) NSString *expire;       //有效期
@property (nonatomic, copy) NSString *member;
@property (nonatomic, copy) NSString *status;
@end
