//
//  GVUserDefaults+AJProperties.h
//  AiJia
//
//  Created by 熊财兴 on 15/1/26.
//  Copyright (c) 2015年 TISIWI. All rights reserved.
//

#import "GVUserDefaults.h"
//#import <CoreLocation/CoreLocation.h>


@interface GVUserDefaults (TSWProperties)

@property (nonatomic, weak) NSString *token;
@property (nonatomic, weak) NSString *refreshToken;
@property (nonatomic, weak) NSString *expire;

@property (nonatomic, weak) NSString *shouldGoHome;

@property (nonatomic, weak) NSString *bookPhoneNumber;
@property (nonatomic, weak) NSString *bookName;
@property (nonatomic, weak) NSString *cityName;
@property (nonatomic, weak) NSString *cityCode;

@property (nonatomic, weak) NSString *searchServiceCityCode;
@property (nonatomic, weak) NSString *searchServiceRound;
@property (nonatomic, weak) NSMutableArray *searchServiceFields;

@property (nonatomic, weak) NSString *searchTalentCityCode;
@property (nonatomic, weak) NSString *searchTalentSeniority;
@property (nonatomic, weak) NSString *searchTalentSalaryMin;
@property (nonatomic, weak) NSString *searchTalentSalaryMax;
@property (nonatomic, weak) NSString *searchTalentTitle;

@end
