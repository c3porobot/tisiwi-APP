//
//  TSWPassValue.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWPassValue.h"

@implementation TSWPassValue
+ (instancetype)sharedValue {
    static TSWPassValue *value = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        value = [[self alloc] init];
    });
    return value;
}
@end
