//
//  CXImageLoader.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

/// Download remote images with AFNetworking
@interface CXImageLoader : NSObject

/// Timeout for remote image downloading - Default is 30 seconds
@property(assign, nonatomic) NSTimeInterval timeoutInterval;

+ (CXImageLoader *)sharedImageLoader;


#if TARGET_OS_IPHONE
/**
 Download remote images from url
 @param url remote image url
 @param imageBlock block for image or error
 */
- (void)loadImageForURL:(NSURL *)url image:(void (^)(UIImage *image, NSError *error))imageBlock;
#endif

/**
 Cancel all image requests
 */
- (void)cancelAllRequests;

/**
 Cancel image request
 @param url remote image url
 */
- (void)cancelRequestForUrl:(NSURL *)url;

/**
 Check image is loaded
 @param url remote image url
 */
- (BOOL)hasLoadedImageURL:(NSURL*)url;

@end
