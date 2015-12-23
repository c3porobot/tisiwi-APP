//
//  TSWContactList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/14.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactList.h"
#import "TSWContact.h"

@implementation TSWContactList

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.contacts) {
            [self.contacts removeAllObjects];
        }
        else {
            self.contacts = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWContact *contact = [[TSWContact alloc] initWithValues:dictionary];
            [self.contacts addObject:contact];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
