//
//  TSWFinanceList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceList.h"
#import "TSWFinance.h"

@implementation TSWFinanceList

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path
{
    return [self initWithBaseURL:url path:path cachePolicyType:kCachePolicyTypeReturnCacheDataOnError];
}

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path cachePolicyType:(CachePolicyType)cachePolicyType
{
    self = [super initWithBaseURL:url path:path cachePolicyType:cachePolicyType];
    if (self) {
        self.page = 1;
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.finances) {
            [self.finances removeAllObjects];
        }
        else {
            self.finances = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWFinance *finance = [[TSWFinance alloc] initWithValues:dictionary];
            [self.finances addObject:finance];
        }
        self.page++;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
