//
//  TSWFeedbackList.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWFeedbackList.h"
//#define FEEDBACK_LIST @"v1/requirement/feedback/"
@implementation TSWFeedbackList

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path
{
    return [self initWithBaseURL:url path:path cachePolicyType:kCachePolicyTypeReturnCacheDataOnError];
}

- (instancetype)initWithBaseURL:(NSURL *)url path:(NSString *)path cachePolicyType:(CachePolicyType)cachePolicyType
{
    self = [super initWithBaseURL:url path:path cachePolicyType:cachePolicyType];
    if (self) {
        self.page = 1;
    }
    return self;
}


- (void)setValue:(id)value forKey:(NSString *)key {
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.feedbacks) {
            [self.feedbacks removeAllObjects];
        }
        else {
            self.feedbacks = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            TSWfeedBack *feedback = [[TSWfeedBack alloc] initWithValues:dictionary];
            [self.feedbacks addObject:feedback];
        }
        //self.page++;
    } else {
        [super setValue:value forKey:key];
    }

}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
@end
