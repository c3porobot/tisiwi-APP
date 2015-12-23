//
//  TSWResultList.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/2.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWResultList.h"
#import "TSWResult.h"

@implementation TSWResultList
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.results) {
            [self.results removeAllObjects];
        }
        else {
            self.results = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWResult *result = [[TSWResult alloc] initWithValues:dictionary];
            [self.results addObject:result];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
