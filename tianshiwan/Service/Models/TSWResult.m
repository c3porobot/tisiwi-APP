//
//  TSWResult.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/2.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWResult.h"
#import "TSWFinance.h"
#import "TSWOther.h"

@interface TSWResult()

@property (nonatomic, strong) NSString *innerType;

@end

@implementation TSWResult
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"type"]){
        _innerType = value;
        [super setValue:value forKey:key];
    }else if ([key isEqualToString:@"items"]) {
       
        if([_innerType isEqualToString:@"financing"]){
            if (![value isKindOfClass:[NSArray class]]) {
                return;
            }
            
            if (self.items) {
               
                [self.items removeAllObjects];
            }
            else {
                self.items = [NSMutableArray array];
            }
            
            for (id dictionary in value) {
                if (![dictionary isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                TSWFinance *finance = [[TSWFinance alloc] initWithValues:dictionary];              
                [self.items addObject:finance];
//                TSWResult *result = [[TSWResult alloc] initWithValues:dictionary];
//                [self.items addObject:result];
            }
        }else{
            if (![value isKindOfClass:[NSArray class]]) {
                return;
            }
            
            if (self.items) {
                [self.items removeAllObjects];
            }
            else {
                self.items = [NSMutableArray array];
            }
            
            for (id dictionary in value) {
                if (![dictionary isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                TSWOther *other = [[TSWOther alloc] initWithValues:dictionary];
                [self.items addObject:other];
            }
        }
        
    }
    else {
        [super setValue:value forKey:key];
    }
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
@end
