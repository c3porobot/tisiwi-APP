//
//  TSWGetPosition.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWGetPosition.h"
#import "TSWTalentPosition.h"

@implementation TSWGetPosition
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.positions) {
            [self.positions removeAllObjects];
        }
        else {
            self.positions = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWTalentPosition *position = [[TSWTalentPosition alloc] initWithValues:dictionary];
            [self.positions addObject:position];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
