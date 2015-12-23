//
//  TSWContact.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/14.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWContact : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *imgUrl_2x;
@property (nonatomic, strong) NSString *imgUrl_3x;

@end
