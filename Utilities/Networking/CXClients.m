//
//  CXClients.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXClients.h"

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"

@interface CXClients ()

@property (nonatomic, strong) NSMutableDictionary *clients;

@end

@implementation CXClients

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clients = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (instancetype)sharedClients
{
    static CXClients *_sharedClients = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClients = [[CXClients alloc] init];
    });
    
    return _sharedClients;
}

- (AFHTTPSessionManager *)clientWithBaseURL:(NSURL *)baseURL
{
    NSParameterAssert(baseURL);
    
    if (![self.clients objectForKey:[baseURL absoluteString]]) {
        AFHTTPSessionManager *client = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        //        client.requestSerializer = [AFJSONRequestSerializer serializer];
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        if ([baseURL.scheme isEqualToString:@"https"]) {
            client.securityPolicy.allowInvalidCertificates = YES;
        }
        [self.clients setValue:client forKey:[baseURL absoluteString]];
    }
    
    return [self.clients objectForKey:[baseURL absoluteString]];
}

@end
