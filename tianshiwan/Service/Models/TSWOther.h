//
//  TSWOther.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWOther : CXResource
@property(nonatomic, strong) NSString *sid;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *company;
@property(nonatomic, strong) NSString *cityCode;
@property(nonatomic, strong) NSString *cityName;
@property(nonatomic, assign) NSInteger like;
@end
