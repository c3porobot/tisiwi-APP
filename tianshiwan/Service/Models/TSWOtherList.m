//
//  TSWOtherList.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWOtherList.h"
#import "TSWOther.h"

@implementation TSWOtherList

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
        
        if (self.others) {
            [self.others removeAllObjects];
        }
        else {
            self.others = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWOther *other = [[TSWOther alloc] initWithValues:dictionary];
            [self.others addObject:other];
        }
        self.page++;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end

