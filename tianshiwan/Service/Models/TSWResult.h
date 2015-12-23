//
//  TSWResult.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/2.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWResult : CXResource

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imgUrl_2x;
@property (nonatomic, strong) NSString *imgUrl_3x;
@property (nonatomic, strong) NSMutableArray *items;

@end
