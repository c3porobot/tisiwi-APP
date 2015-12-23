//
//  TSWValidates.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWValidates.h"

#import "TSWValidate.h"



@interface TSWValidates ()

@property (nonatomic, strong) TSWValidate *loginValidate;

@end

@implementation TSWValidates

+ (instancetype)sharedValidates;
{
    static TSWValidates *_sharedValidates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedValidates = [[TSWValidates alloc] init];
        
        _sharedValidates.loginValidate = [TSWValidate new];
        _sharedValidates.loginValidate.timeout = 60;
        _sharedValidates.loginValidate.code = @"";
    });
    
    return _sharedValidates;
}

@end
