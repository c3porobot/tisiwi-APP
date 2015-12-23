//
//  CXDataCache.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXDataCache.h"

#import "EGOCache.h"

static const NSTimeInterval kCXDataCacheTimeoutInterval = 31536000; //缓存秒数，365天：365 * 24 * 60 * 60

@interface CXDataCache ()

@property (nonatomic, strong) NSMutableDictionary* memoryInfo;

@property (nonatomic, strong) EGOCache *cache;

@end

@implementation CXDataCache

+ (CXDataCache *)sharedDataCache
{
    static CXDataCache *_sharedDataCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imageCacheDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"CXDataCache"];
        _sharedDataCache = [[CXDataCache alloc] initWithCacheDirectory:imageCacheDirectory];
    });
    return _sharedDataCache;
}

- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory
{
    if((self = [super init])) {
        _memoryInfo = [NSMutableDictionary dictionary];
        _cache = [[EGOCache alloc] initWithCacheDirectory:cacheDirectory];
        [_cache setDefaultTimeoutInterval:kCXDataCacheTimeoutInterval];
    }
    return self;
}

- (id<NSCoding>)objectForKey:(NSString*)key
{
    return [_cache objectForKey:[NSString stringWithFormat:@"Data-%@", key]];
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key
{
    [_cache setObject:anObject forKey:[NSString stringWithFormat:@"Data-%@", key]];
}

@end

