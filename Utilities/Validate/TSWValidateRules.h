//
//  TSWValidates.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSWValidateRules : NSObject

//邮箱
+ (BOOL)validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile;

+ (BOOL)validatePassword:(NSString *)passWord;

+ (BOOL)networkIsReachable;// if network is connected

@end
