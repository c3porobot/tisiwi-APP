//
//  TSWArticleList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWArticleList.h"
#import "TSWArticle.h"

@implementation TSWArticleList

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path
{
    self.isInfinite = false;
    return [self initWithBaseURL:url path:path cachePolicyType:kCachePolicyTypeReturnCacheDataOnError];
}

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path cachePolicyType:(CachePolicyType)cachePolicyType
{
    self = [super initWithBaseURL:url path:path cachePolicyType:cachePolicyType];
    if (self) {
        self.page = 1;
    }
    self.isInfinite = false;
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.articles) {
            [self.articles removeAllObjects];
        }
        else {
            self.articles = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWArticle *article = [[TSWArticle alloc] initWithValues:dictionary];
            [self.articles addObject:article];
        }
        
        self.page++;
    }
    else {
        [super setValue:value forKey:key];
    }
}

@end

