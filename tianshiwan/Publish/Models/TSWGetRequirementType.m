//
//  TSWGetRequirementType.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWGetRequirementType.h"
#import "TSWOtherRequirementType.h"
@implementation TSWGetRequirementType
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.types) {
            [self.types removeAllObjects];
        }
        else {
            self.types = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWOtherRequirementType *type = [[TSWOtherRequirementType alloc] initWithValues:dictionary];
            [self.types addObject:type];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
