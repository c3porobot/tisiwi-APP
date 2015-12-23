//
//  CXResource.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#import <AdSupport/AdSupport.h>
#import "CXClients.h"
#import "AFHTTPSessionManager.h"
#import "TSWLoginViewController.h"

#import "CXLog.h"

#import "CXDataCache.h"

#import "NSString+CXExtensions.h"

#import "GVUserDefaults+TSWProperties.h"

#import "AppDelegate.h"
//#import "AJLoginController.h"

typedef NS_ENUM(NSInteger, ResourceStatus) {
    ResourceStatusNotProcessed = 0, // 0000
    ResourceStatusProcessing = 1 << 1,// 0010
    ResourceStatusProcessed = 1 << 2, // 0100
    ResourceStatusCache = 6,// 0110
    ResourceStatusRequestProceed = 1<<3,//0x1000
}; // & 2是处理中

NSString * const CXResourceErrorDomain = @"cx.resource.request.error.response";

@interface CXResource ()
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSString *resourcePath;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) ResourceStatus loadingStatus;

@property (nonatomic, strong) NSString *md5Hash;

@property (nonatomic, assign) CachePolicyType cachePolicyType;

@property (nonatomic, strong) NSMutableArray *saveCacheDataKeyArray;
@property (nonatomic, strong) NSMutableArray *cacheDataKeyArray;

@property (nonatomic, assign) BOOL isAccessNetworkData;

@end


@implementation CXResource

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path
{
    return [self initWithBaseURL:url path:path cachePolicyType:kCachePolicyTypeReturnCacheDataOnError];
}

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path cachePolicyType:(CachePolicyType)cachePolicyType
{
    self = [super init];
    if (self) {
        self.baseURL = url;
        self.resourcePath = path;
        self.cachePolicyType = cachePolicyType;
        
        self.loadingStatus = ResourceStatusNotProcessed;
        
        self.saveCacheDataKeyArray = [NSMutableArray array];
        self.cacheDataKeyArray = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithValues:(id)values
{
    self = [super init];
    if (self) {
        self.baseURL = nil;
        self.resourcePath = nil;
        self.cachePolicyType = kCachePolicyTypeNone;
        
        self.saveCacheDataKeyArray = [NSMutableArray array];
        self.cacheDataKeyArray = [NSMutableArray array];
        
        [self setValues:values];
        
        self.loadingStatus = ResourceStatusProcessed;
    }
    
    return self;
}

#pragma mark Public Methods
- (void)loadDataWithParameters:(NSDictionary*)parameters

{
    [self loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:parameters];
}

- (void)loadDataWithRequestMethodType:(HttpRequestMethodType)methodType parameters:(NSDictionary*)parameters
{
    [self loadDataWithRequestMethodType:methodType parameters:parameters dataType:kHttpRequestDataTypeNormal];
}

- (void)loadDataWithRequestMethodType:(HttpRequestMethodType)methodType parameters:(NSDictionary*)parameters dataType:(HttpRequestDataType)dataType;
{
    if (self.isLoading) return;
    self.error = nil;
    
    NSDictionary *allParameters = [self allParametersWithParameters:parameters dataType:dataType];
    
    DDLogDebug(@"Loading %@%@ allParameters: %@", self.baseURL, self.resourcePath, allParameters);
    
    if (dataType == kHttpRequestDataTypeNormal) {
        if (self.cachePolicyType == kCachePolicyTypeReturnCacheDataAndRequestNetwork) {
            NSString *cacheKey = [self cacheKeyWithParameters:allParameters];
            if (cacheKey) {
                if ([self loadCacheDataWithCacheKey:cacheKey]) {
                    self.loadingStatus = ResourceStatusCache;
                    if (![[CXDataCache sharedDataCache] objectForKey:cacheKey]) {
                        [self clearCacheData];
                    }
                }
            }
        }
        
        if (methodType == kHttpRequestMethodTypeGet) {
            [self GET:allParameters];
        }
        else if (methodType == kHttpRequestMethodTypePatch) {
            [self PATCH:allParameters];
        }
        else if (methodType == kHttpRequestMethodTypePost) {
            [self POST:allParameters];
        }
        else if (methodType == kHttpRequestMethodTypePut) {
            [self PUT:allParameters];
        }
        else if (methodType == kHttpRequestMethodTypeDelete) {
            [self DELETE:allParameters];
        }
    }
    else {
        [[[CXClients sharedClients] clientWithBaseURL:self.baseURL] POST:self.resourcePath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSString *key in [allParameters allKeys]) {
                id object = [allParameters objectForKey:key];
                
                if ([object isKindOfClass:[UIImage class]]) {
                    NSData* imageData = UIImageJPEGRepresentation((UIImage *)object, 0.5F);
                    
                    [formData appendPartWithFileData:imageData name:key fileName:@"file.jpg" mimeType:@"image/jpeg"];
                }else if ([object isKindOfClass:[NSData class]]) {
                    [formData appendPartWithFileData:object name:@"file" fileName:key mimeType:@"application/octet-stream"];
                }else {
                    [formData appendPartWithFormData:[[object description] dataUsingEncoding:((AFHTTPSessionManager *)[[CXClients sharedClients] clientWithBaseURL:self.baseURL]).requestSerializer.stringEncoding] name:key];
                }
            }
        } success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            [self loadedResponseObject:responseObject parameters:parameters isCanSave:NO];
            //         DDLogDebug(@"Loading %@ responseObject: %@", self.resourcePath, responseObject);
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
            [self loadFailWithError:error parameters:parameters];
        }];
    }
    // self.loadingStatus = ResourceStatusProcessing;
    //    self.loadingStatus = ResourceStatusRequestProceed;
}

- (void)needsReload
{
    self.loadingStatus = ResourceStatusNotProcessed;
}

- (void)needsload
{
    self.loadingStatus = ResourceStatusNotProcessed;
}

- (void)setValues:(id)values
{
    
    if (values && [values isKindOfClass:[NSDictionary class]]) {
        [values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setValue:obj forKey:key];
        }];
    }
}

- (void)loadFailWithError:(NSError *)error parameters:(NSDictionary*)parameters
{
    NSString *cacheKey = [self cacheKeyWithParameters:parameters];
    
    BOOL isLoadedCache = NO;
    
    if (error.code == -1009) {
        self.isAccessNetworkData = NO;
    }
    if (cacheKey && self.cachePolicyType == kCachePolicyTypeReturnCacheDataOnError) {
        if (cacheKey) {
            if ([self loadCacheDataWithCacheKey:cacheKey]) {
                isLoadedCache = YES;
                self.loadingStatus = ResourceStatusCache;
                if (![[CXDataCache sharedDataCache] objectForKey:cacheKey]) {
                    [self clearCacheData];
                }
            }
        }
    }
    if (!isLoadedCache) {
        self.error = error;
    }
    else {
        self.error = nil;
    }
    self.loadingStatus = ResourceStatusNotProcessed;
}

- (void)clearCacheData
{
    
}


#pragma mark KVC
- (BOOL)isTSWBaseURL
{
    return YES;
    //    return (self.baseURL /*&& [self.baseURL.absoluteString containsString:@""]*/);
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        [super setValue:[NSString stringWithFormat:@"%@", value] forKey:key];
    }
    else if ([value isKindOfClass:[NSNull class]]) {
        [super setValue:nil forKey:key];
    }
    else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}

#pragma mark Private Methods
- (NSString *)cacheKeyWithParameters:(NSDictionary *)parameters
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    for (NSString *key in parameters.allKeys) {
        if (![key isEqualToString:@"appVersion"]) {
            dictionary[key] = [parameters valueForKey:key];
        }
    }
    
    NSString * jsonString = [self toJSONString:dictionary];
    
    if (jsonString) {
        return [[NSString stringWithFormat:@"%@%@%@", self.baseURL, self.resourcePath, jsonString] cx_MD5];
    }
    else {
        return nil;
    }
}

- (NSString *)toJSONString:(NSDictionary *)dictionary
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

- (void)saveValues:(id)values parameters:(NSDictionary *)parameters
{
    NSString *cacheKey = [self cacheKeyWithParameters:parameters];
    
    if (cacheKey && self.cachePolicyType != kCachePolicyTypeNone) {
        if (![self.saveCacheDataKeyArray containsObject:cacheKey]) {
            [[CXDataCache sharedDataCache] setObject:values forKey:cacheKey];
            [self.saveCacheDataKeyArray addObject:cacheKey];
        }
    }
}

- (BOOL)loadCacheDataWithCacheKey:(NSString *)cacheKey
{
    if (self.isAccessNetworkData) {
        return NO;
    }
    
    if (![self.cacheDataKeyArray containsObject:cacheKey] || self.cachePolicyType == kCachePolicyTypeReturnCacheDataOnError) {
        id values = [[CXDataCache sharedDataCache] objectForKey:cacheKey];
        if (values) {
            [self setValues:values];
            [self.cacheDataKeyArray addObject:cacheKey];
            return YES;
        }else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

- (NSDictionary *)allParametersWithParameters:(NSDictionary *)parameters dataType:(HttpRequestDataType)dataType
{
    NSMutableDictionary *allParameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    CGFloat wid = [UIScreen mainScreen].bounds.size.width;
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    allParameters[@"appVersion"] = appVersion;
    allParameters[@"deviceToken"] = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    allParameters[@"osType"] = @(1);
    allParameters[@"parterValue"] = @(100);
    allParameters[@"width"] =@(scale_screen*wid);
    
    if([GVUserDefaults standardUserDefaults].cityCode)
    {
        allParameters[@"cityCode"] = [GVUserDefaults standardUserDefaults].cityCode;
    }
    
    
    if ([GVUserDefaults standardUserDefaults].token) {
        allParameters[@"token"] = [GVUserDefaults standardUserDefaults].token;
    }
    
    if ([self isTSWBaseURL] && dataType == kHttpRequestDataTypeNormal) {
//        NSString *str = [self toJSONString:allParameters];
//        return @{@"req":str};
        return allParameters;
    }
    else {
        return allParameters;
    }
}

- (void)GET:(NSDictionary*)parameters
{
    [[[CXClients sharedClients] clientWithBaseURL:self.baseURL] GET:self.resourcePath parameters:parameters success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        [self loadedResponseObject:responseObject parameters:parameters isCanSave:YES];
        DDLogDebug(@"Loading %@ responseObject: %@", self.resourcePath, responseObject);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
        [self loadFailWithError:error parameters:parameters];
    }];
}

- (void)PATCH:(NSDictionary*)parameters
{
    [[[CXClients sharedClients] clientWithBaseURL:self.baseURL] PATCH:self.resourcePath parameters:parameters success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        [self loadedResponseObject:responseObject parameters:parameters isCanSave:YES];
        DDLogDebug(@"Loading %@ responseObject: %@", self.resourcePath, responseObject);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
        [self loadFailWithError:error parameters:parameters];
    }];
}

- (void)POST:(NSDictionary*)parameters
{
    [[[CXClients sharedClients] clientWithBaseURL:self.baseURL] POST:self.resourcePath parameters:parameters success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        [self loadedResponseObject:responseObject parameters:parameters isCanSave:YES];
        DDLogDebug(@"Loading %@ responseObject: %@", self.resourcePath, responseObject);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
        [self loadFailWithError:error parameters:parameters];
    }];
}

- (void)PUT:(NSDictionary*)parameters
{
    [[[CXClients sharedClients] clientWithBaseURL:self.baseURL] PUT:self.resourcePath parameters:parameters success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        [self loadedResponseObject:responseObject parameters:parameters isCanSave:YES];
        DDLogDebug(@"Loading %@ responseObject: %@", self.resourcePath, responseObject);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
        [self loadFailWithError:error parameters:parameters];
    }];
}

- (void)DELETE:(NSDictionary*)parameters
{
    [[[CXClients sharedClients] clientWithBaseURL:self.baseURL] DELETE:self.resourcePath parameters:parameters success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        [self loadedResponseObject:responseObject parameters:parameters isCanSave:YES];
        DDLogDebug(@"Loading %@ responseObject: %@", self.resourcePath, responseObject);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
        [self loadFailWithError:error parameters:parameters];
    }];
}

- (void)loadedResponseObject:(id)responseObject parameters:(NSDictionary *)parameters isCanSave:(BOOL)isCanSave
{
    if (responseObject && ![responseObject isKindOfClass:[NSDictionary class]]) {
        self.isAccessNetworkData = YES;
        if (isCanSave) {
            [self saveValues:responseObject parameters:parameters];
        }
        [self setValues:responseObject];
        self.loadingStatus = ResourceStatusProcessed;
        return;
    }
    
    NSArray *allKeys = (NSArray *)[responseObject allKeys];
    
    if ([allKeys containsObject:@"respCode"] && [allKeys containsObject:@"errCode"] && [allKeys containsObject:@"errMsg"] && [allKeys containsObject:@"response"])
    {
        id respCode = responseObject[@"respCode"];
        id errCode = responseObject[@"errCode"];
        id errMsg = responseObject[@"errMsg"];
        id response = [responseObject objectForKey:@"response"];
        
        if ([respCode integerValue] == HttpResponseCodeSuccess) {
            self.isAccessNetworkData = YES;
            if (isCanSave) {
                [self saveValues:response parameters:parameters];
            }
            [self setValues:response];
            
            self.loadingStatus = ResourceStatusProcessed;//attention
        }
        else {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            
            [userInfo setValue:@"Request error response" forKey:NSLocalizedDescriptionKey];
            
            if (errCode && errMsg) {
                [userInfo setValue:[NSString stringWithFormat:@"%@", errMsg] forKey:NSLocalizedFailureReasonErrorKey];
            }
            else {
                [userInfo setValue:[NSString stringWithFormat:@"Response Data: %@", responseObject] forKey:NSLocalizedFailureReasonErrorKey];
            }
            
            NSError *error = [[NSError alloc] initWithDomain:CXResourceErrorDomain code:[respCode integerValue] userInfo:userInfo];
            
            if ([errCode isEqualToString:@"E_INVALID_TOKEN"]) {
                self.error = error;
                
                self.loadingStatus = ResourceStatusNotProcessed;
                
                [GVUserDefaults standardUserDefaults].token = nil;
                [GVUserDefaults standardUserDefaults].refreshToken = nil;
                [GVUserDefaults standardUserDefaults].expire = nil;
                
                AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                
//                AJLoginController *loginController = [[AJLoginController alloc] init];
//                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
//                [app.window.rootViewController presentViewController:navigationController animated:YES completion:^{
                
//                }];
                TSWLoginViewController *loginController = [[TSWLoginViewController alloc] init];
//                loginController.delegate = self;
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
                [app.window.rootViewController presentViewController:navigationController animated:YES completion:^{
                }];
            }
            else {
                DDLogDebug(@"Loading %@ failed: %@", self.resourcePath, error);
                [self loadFailWithError:error parameters:parameters];
            }
        }
    }
    else {
        self.isAccessNetworkData = YES;
        if (isCanSave) {
            [self saveValues:responseObject parameters:parameters];
        }
        [self setValues:responseObject];
        self.loadingStatus = ResourceStatusProcessed;
        return;
    }
}

#pragma mark Convenience Accessors

- (BOOL)isLoading
{
    return self.loadingStatus & 2; //0010为loading
}

- (BOOL)isLoadCache
{
    return self.loadingStatus == ResourceStatusCache;
}

- (BOOL)isLoaded
{
    return (self.loadingStatus == ResourceStatusProcessed) || (self.loadingStatus == ResourceStatusCache);
}
- (BOOL)isStartRequest
{
    return (self.loadingStatus == ResourceStatusRequestProceed);
}

@end
