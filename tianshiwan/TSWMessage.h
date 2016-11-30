//
//  TSWMessage.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWMessage : CXResource

@property (nonatomic, strong) NSString *sid; //唯一标识
@property (nonatomic, strong) NSString *title; //标题
@property (nonatomic, strong) NSString *type; //类型(article 文章通知 ,financing 融资,normal 其他,personnel 人才,checkout 审核通知)
@property (nonatomic, strong) NSString *status; //是否查看状态
@property (nonatomic, strong) NSString *created_at; //通知时间
@end
