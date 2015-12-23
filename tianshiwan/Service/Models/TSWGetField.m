//
//  TSWGetField.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWGetField.h"
#import "TSWServiceField.h"

@implementation TSWGetField
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.fields) {
            [self.fields removeAllObjects];
        }
        else {
            self.fields = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWServiceField *field = [[TSWServiceField alloc] initWithValues:dictionary];
            [self.fields addObject:field];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
