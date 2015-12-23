//
//  TSWCommonTool.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWCommonTool.h"
#import "AppDelegate.h"


@implementation TSWCommonTool

/**
 *  四舍五入   折扣
 *
 *  @param number 服务器返回折扣数据
 *
 *  @return 四舍五入后的数据   保留小数点后一位
 */
+ (NSString *)getSubStringFromDoubleString:(NSString *)number
{
    if(number == nil)
        return nil;
    if(number.length <= 3)
        return number;
    
    if(number.length > 6)//大于6位，忽略
    {
        number = [number substringWithRange:NSMakeRange(0, 6)];
    }
    
    double num = [number doubleValue];
    num *= 100;
    NSInteger num1 = num;
    double realNumber = num/10;
    num1 = num1%10;
    
    if(num1 >= 5)
    {
        realNumber += 1;
    }
    realNumber = realNumber/10;
    
    NSString *numberString = [NSString stringWithFormat:@"%f", realNumber];
    
    NSString *subStr = [numberString substringWithRange:NSMakeRange(0, 3)];
    
    return subStr;
}

+ (void)setDiddFontForView:(UILabel *)vw size4:(CGFloat)size4 size6:(CGFloat)size6 size6p:(CGFloat)size6p
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    if(width == 375)//6
    {
        [vw setFont:[UIFont systemFontOfSize:size6]];
    }
    else if(width == 414)//p
    {
        [vw setFont:[UIFont systemFontOfSize:size6p]];
    }
    else
    {
        [vw setFont:[UIFont systemFontOfSize:size4]];
    }
}

+(DeviceIdiomCode)getCurrentDeviceModelIdiom
{
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    if(height == 667)//6
    {
        return DeviceIdiomIphone6;
    }
    else if(height == 736)//p
    {
        return DeviceIdiomIphone6p;
    }
    else if(height == 568)
    {
        return DeviceIdiomIphone5;
    }
    else
    {
        return DeviceIdiomIphone4;
    }
}

+ (dispatch_queue_t)getDelegateWorkQueueForconsumptionOperation
{
    AppDelegate *delgat = [UIApplication sharedApplication].delegate;
    
    if(!delgat.workQueue)
    {
        delgat.workQueue = dispatch_queue_create("AijiaWorkQueue", 0);
    }
    return delgat.workQueue;
}



@end

