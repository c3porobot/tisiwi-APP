//
//  TSWTalentList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTalentList.h"
#import "TSWTalent.h"

@implementation TSWTalentList

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
        
        if (self.talents) {
            [self.talents removeAllObjects];
        }
        else {
            self.talents = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWTalent *talent = [[TSWTalent alloc] initWithValues:dictionary];
            [self.talents addObject:talent];
        }
        self.page++;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end
