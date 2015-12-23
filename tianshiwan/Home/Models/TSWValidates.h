//
//  TSWValidates.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TSWValidate;

@interface TSWValidates : NSObject

@property (nonatomic, readonly) TSWValidate *loginValidate;

+ (instancetype)sharedValidates;

@end
