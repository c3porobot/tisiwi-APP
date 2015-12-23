//
//  TSWServiceList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWServiceList.h"
#import "TSWService.h"

@implementation TSWServiceList

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.services) {
            [self.services removeAllObjects];
        }
        else {
            self.services = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWService *service = [[TSWService alloc] initWithValues:dictionary];
            [self.services addObject:service];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
