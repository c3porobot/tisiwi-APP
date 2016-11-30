//
//  TSWfeedBack.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

@interface TSWfeedBack : CXResource

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *created_at;

@end
