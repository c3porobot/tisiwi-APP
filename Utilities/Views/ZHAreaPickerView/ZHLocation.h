//
//  ZHLocation.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLocation : NSObject

@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *cityCode;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
