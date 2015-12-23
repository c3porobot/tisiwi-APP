//
//  TSWValidate.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSWValidate : NSObject

@property (nonatomic, strong) NSString *mobile;

@property (nonatomic, strong) NSString *registerKey;

@property (nonatomic, assign) NSUInteger timeout;

@property (nonatomic, readonly) NSUInteger surplusTime;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, readonly) BOOL isStartTime;

- (void)startTime;

@end
