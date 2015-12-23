//
//  TSWValidates.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWValidateRules.h"
#import "Reachability.h"



@implementation TSWValidateRules

//邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13，14，15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^1([34578][0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord
{
    return (passWord.length > 5 && passWord.length < 21);
}


+ (BOOL)networkIsReachable
{
    Reachability *rrach = [Reachability reachabilityForInternetConnection];
    if ( NotReachable == [rrach currentReachabilityStatus] )
    {
        return NO;
    }
    return YES;
}

@end
