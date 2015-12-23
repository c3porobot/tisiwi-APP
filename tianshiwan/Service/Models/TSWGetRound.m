//
//  TSWGetRound.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWGetRound.h"
#import "TSWServiceRound.h"

@implementation TSWGetRound
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.rounds) {
            [self.rounds removeAllObjects];
        }
        else {
            self.rounds = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWServiceRound *round = [[TSWServiceRound alloc] initWithValues:dictionary];
            [self.rounds addObject:round];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
