//
//  TSWPassValue.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSWPassValue : NSObject
@property (nonatomic, assign) NSInteger passvalue;

+(instancetype)sharedValue;
@end
