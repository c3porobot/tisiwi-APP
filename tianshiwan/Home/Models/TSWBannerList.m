//
//  TSWBannerList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWBannerList.h"
#import "TSWBanner.h"

@implementation TSWBannerList
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.banners) {
            [self.banners removeAllObjects];
        }
        else {
            self.banners = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWBanner *banner = [[TSWBanner alloc] initWithValues:dictionary];
            [self.banners addObject:banner];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
