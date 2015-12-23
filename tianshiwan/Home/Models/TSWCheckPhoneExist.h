//
//  TSWCheckPhoneExist.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

#define CHECK_PHONE_EXIST @"v1/checkPhoneExist"

@interface TSWCheckPhoneExist : CXResource

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *expire;

@end
