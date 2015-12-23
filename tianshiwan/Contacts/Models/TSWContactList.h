//
//  TSWContactList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/14.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

#define CONTACT_LIST @"v1/member"

@interface TSWContactList : CXResource

@property (nonatomic, strong) NSMutableArray *contacts;
@property (nonatomic, strong) NSString *pinYin;

@end
