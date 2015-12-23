//
//  CXResource.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kResourceLoadingStatusKeyPath @"loadingStatus"

typedef NS_ENUM(NSInteger, HttpResponseCode)
{
    HttpResponseCodeSuccess = 0X000001L,
    HttpResponseCodeFAILED = 0X000002L,
    HttpResponseCodeDataTransferEmpty = 0X000003L,
    HttpResponseCodeTokenExpire = 0X100001L,
    HttpResponseCodeUserNotExists = 0X100002L,
    HttpResponseCodeUserNotLogin = 0X100003L,
};

typedef NS_ENUM(NSInteger, HttpRequestDataType)
{
    kHttpRequestDataTypeNormal,			// for normal data Get/Patch/Post/Put/Delete, such as "user=name&password=psd"
    kHttpRequestDataTypeMultipart,      // for uploading images and files.
};

typedef NS_ENUM(NSInteger, HttpRequestMethodType)
{
    kHttpRequestMethodTypeGet = 0,
    kHttpRequestMethodTypePatch,
    kHttpRequestMethodTypePost,
    kHttpRequestMethodTypePut,
    kHttpRequestMethodTypeDelete,
};

typedef NS_ENUM(NSInteger, CachePolicyType)
{
    kCachePolicyTypeNone = 0, // 不使用缓存
    kCachePolicyTypeReturnCacheDataOnError, // 数据请求失败时(无网络时首页非空，或者某些离线策略)使用缓存
    kCachePolicyTypeReturnCacheDataAndRequestNetwork, // 先使用缓存加载 然后再请求数据刷新
};

@interface CXResource : NSObject

@property (nonatomic, readonly) NSString *resourcePath;

@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) BOOL isLoaded;
@property (nonatomic, readonly) BOOL isLoadCache;
@property (nonatomic, readonly) BOOL isLoading;

@property (nonatomic, readonly) BOOL isAccessNetworkData;

/**
 @param url 接口Base URL 如：[NSURL URLWithString:@"http://"] 不可以为nil
 @param path 接口地址 如：@"company/home"
 @param cachePolicyType 缓存策略
 */
- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path cachePolicyType:(CachePolicyType)cachePolicyType;

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path;
- (instancetype)initWithValues:(id)values;


- (void)loadDataWithParameters:(NSDictionary*)parameters;

- (void)loadDataWithRequestMethodType:(HttpRequestMethodType)methodType parameters:(NSDictionary*)parameters;

- (void)loadDataWithRequestMethodType:(HttpRequestMethodType)methodType parameters:(NSDictionary*)parameters dataType:(HttpRequestDataType)dataType;

- (void)needsReload;

- (void)needsload;

- (void)setValues:(id)response; //如果response是非字典类型，子类需要Override

#pragma mark Override
- (void)clearCacheData;

- (BOOL)isStartRequest;


@end
