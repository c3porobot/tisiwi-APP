//
//  TSWMyRequirementsList.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWMyRequirementsList.h"
#import "TSWMyRequirement.h"
@implementation TSWMyRequirementsList
- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"list"]) {
        if (![value isKindOfClass:[NSArray class]]) {
            return;
        }
        
        if (self.myRequirements) {
            [self.myRequirements removeAllObjects];
        }
        else {
            self.myRequirements = [NSMutableArray array];
        }
        
        for (id dictionary in value) {
            TSWMyRequirement *myRequirement = [[TSWMyRequirement alloc] initWithValues:dictionary];
            [self.myRequirements addObject:myRequirement];
        }
    }
    else {
        [super setValue:value forKey:key];
    }
}
@end
