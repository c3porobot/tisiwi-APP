//
//  CXImageCache.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXImageCache.h"

#import "EGOCache.h"

static const NSTimeInterval kCXImageCacheTimeoutInterval = 31536000; //缓存秒数，365天：365 * 24 * 60 * 60

@interface CXImageCache ()

@property (nonatomic, strong) NSMutableDictionary* memoryInfo;

@property (nonatomic, strong) EGOCache *cache;

@end

@implementation CXImageCache

+ (CXImageCache *)sharedImageCache
{
    static CXImageCache *_sharedImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *imageCacheDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"CXImageCache"];
        _sharedImageCache = [[CXImageCache alloc] initWithCacheDirectory:imageCacheDirectory];
    });
    return _sharedImageCache;
}

- (id)initWithCacheDirectory:(NSString*)cacheDirectory
{
    if((self = [super init])) {
        _memoryInfo = [NSMutableDictionary dictionary];
        _cache = [[EGOCache alloc] initWithCacheDirectory:cacheDirectory];
        [_cache setDefaultTimeoutInterval:kCXImageCacheTimeoutInterval];
    }
    return self;
}

#if TARGET_OS_IPHONE
- (void)setImage:(UIImage *)anImage forPath:(NSString *)path
{
    if ([path hasPrefix:@"http"]) {
        [self setImage:anImage forURL:[NSURL URLWithString:path]];
    }
    else {
        [_cache setImage:anImage forKey:[NSString stringWithFormat:@"Image-%lu@2x.png", (unsigned long)[path hash]]];
    }
}

- (UIImage *)imageForPath:(NSString *)path
{
    if ([path hasPrefix:@"http"]) {
        return [self imageForURL:[NSURL URLWithString:path]];
    }else {
        return [_cache imageForKey:[NSString stringWithFormat:@"Image-%lu@2x.png", (unsigned long)[path hash]]];
    }
}

- (void)setImage:(UIImage *)anImage forURL:(NSURL *)url
{
    [_cache setImage:anImage forKey:[NSString stringWithFormat:@"Image-%lu@2x.png", (unsigned long)[[url description] hash]]];
}

- (UIImage *)imageForURL:(NSURL*)url
{
    return [_cache imageForKey:[NSString stringWithFormat:@"Image-%lu@2x.png", (unsigned long)[[url description] hash]]];
}
#endif

- (BOOL)hasCacheForPath:(NSString *)path
{
    if ([path hasPrefix:@"http"]) {
        return [self hasCacheForURL:[NSURL URLWithString:path]];
    }
    else {
        return [_cache hasCacheForKey:[NSString stringWithFormat:@"Image-%lu@2x.png", (unsigned long)[path hash]]];
    }
}

- (BOOL)hasCacheForURL:(NSURL *)url
{
    return [_cache hasCacheForKey:[NSString stringWithFormat:@"Image-%lu@2x.png", (unsigned long)[[url description] hash]]];
}

@end
