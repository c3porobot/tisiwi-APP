//
//  TSWTalentDetail.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
//#define TALENT_DETAIL @"v1/service/personnel"
#define TALENT_DETAIL @"v1/service/personnel/mberid/"
@interface TSWTalentDetail: CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *seniority;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, strong) NSString *titles;
@property (nonatomic, strong) NSString *tel;
@property (nonatomic, strong) NSString *introduction;
@property (nonatomic, strong) NSString *wechat; //微信
@property (nonatomic, strong) NSString *email;  //email
@property (nonatomic, assign) NSInteger hasAttachment;
@property (nonatomic, copy) NSString *storestatus;
@property (nonatomic, copy) NSString *attachment; //测试

@property (nonatomic, copy) NSString *updated_at; //更新时间
@property (nonatomic, copy) NSString *created_at; //创建时间
@end
