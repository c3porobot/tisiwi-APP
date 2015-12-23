//
//  TSWFeedback.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"

#define TSW_FEEDBACK @"v1/feedback"

@interface TSWFeedback : CXResource

@property (nonatomic, strong) NSString *feedbackId;

@end
