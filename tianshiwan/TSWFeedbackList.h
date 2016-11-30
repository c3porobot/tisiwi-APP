//
//  TSWFeedbackList.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#import "TSWfeedBack.h"
#define FEEDBACK_LIST @"v1/requirement/feedback/"

@interface TSWFeedbackList : CXResource

@property (nonatomic, strong) NSMutableArray *feedbacks;
@property (nonatomic, assign) NSInteger page;
@end
