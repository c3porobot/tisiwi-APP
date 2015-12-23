//
//  TSWMyRequirementsList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define MY_REQUIREMENTS_LIST @"v1/requirement"
@interface TSWMyRequirementsList : CXResource
@property (nonatomic,strong) NSMutableArray *myRequirements;
@end
