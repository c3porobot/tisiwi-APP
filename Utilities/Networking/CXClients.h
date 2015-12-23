//
//  CXClients.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface CXClients : NSObject

+ (instancetype)sharedClients;

/**
 Creates and return an `AFHTTPSessionManager`
 */
- (AFHTTPSessionManager *)clientWithBaseURL:(NSURL *)baseURL;

@end
