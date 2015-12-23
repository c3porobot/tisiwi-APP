//
//  CXImageCache.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

@interface CXImageCache : NSObject

+ (CXImageCache *)sharedImageCache;

#if TARGET_OS_IPHONE
- (void)setImage:(UIImage*)anImage forPath:(NSString *)path;
- (UIImage*)imageForPath:(NSString *)path;

- (void)setImage:(UIImage *)anImage forURL:(NSURL *)url;
- (UIImage *)imageForURL:(NSURL*)url;
#endif

- (BOOL)hasCacheForPath:(NSString *)path;

@end
