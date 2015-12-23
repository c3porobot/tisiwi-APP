//
//  TSWMyRequirement.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWMyRequirement : CXResource
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger status;
@end
