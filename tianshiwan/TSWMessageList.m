//
//  TSWMessageList.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWMessageList.h"

@implementation TSWMessageList
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
        
        if (self.messages) {
            [self.messages removeAllObjects];
        }
        else {
            self.messages = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWMessage *message = [[TSWMessage alloc] initWithValues:dictionary];
            [self.messages addObject:message];
        }
        self.page++;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
