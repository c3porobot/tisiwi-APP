//
//  TSWTalentList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define TALENT_LIST @"v1/service/personnel"
#define TALENT_DETAIL @"v1/service/personnel/mberid/"

@interface TSWTalentList : CXResource
@property (nonatomic, strong) NSMutableArray *talents;
@property (nonatomic, assign) NSInteger page;
@end
