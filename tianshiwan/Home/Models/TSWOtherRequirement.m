//
//  TSWOtherRequirement.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWOtherRequirement.h"

@implementation TSWOtherRequirement
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        [super setValue:value forKey:@"requirementDesc"];
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
