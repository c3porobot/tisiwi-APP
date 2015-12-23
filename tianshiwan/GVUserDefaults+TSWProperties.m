//
//  GVUserDefaults+AJProperties.m
//  AiJia
//
//  Created by 熊财兴 on 15/1/26.
//  Copyright (c) 2015年 AiJia. All rights reserved.
//

#import "GVUserDefaults+TSWProperties.h"

@implementation GVUserDefaults (TSWProperties)

@dynamic token;
@dynamic refreshToken;
@dynamic expire;
@dynamic shouldGoHome;
@dynamic cityName;
@dynamic cityCode;
@dynamic bookPhoneNumber;
@dynamic bookName;
@dynamic searchServiceCityCode;
@dynamic searchServiceRound;
@dynamic searchServiceFields;

@dynamic searchTalentCityCode;
@dynamic searchTalentSeniority;
@dynamic searchTalentSalaryMin;
@dynamic searchTalentSalaryMax;
@dynamic searchTalentTitle;

- (NSDictionary *)setupDefaults {
    return @{
             @"searchServiceCityCode":@"",
             @"searchServiceRound":@"",
             @"searchServiceFields":@[],
             @"searchTalentCityCode":@"",
             @"searchTalentSeniority":@"",
             @"searchTalentSalaryMin":@"",
             @"searchTalentSalaryMax":@"",
             @"searchTalentTitle":@"",
             @"shouldGoHome":@"NO"
             };
}

#pragma mark - convert key
- (NSString *)transformKey:(NSString *)key {
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] uppercaseString]];
    return [NSString stringWithFormat:@"TSWUserDefault%@", key];
}

@end
