//
//  TSWMessageList.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#import "TSWMessage.h"

#define MESSAGE_LIST @"v1/message/"

@interface TSWMessageList : CXResource
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, assign) NSInteger page;
@end
