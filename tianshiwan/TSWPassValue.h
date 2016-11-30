//
//  TSWPassValue.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSWPassValue : NSObject
@property (nonatomic, assign) NSInteger passvalue; //人才界面传值
@property (nonatomic, assign) NSInteger serviceValue; //服务界面传值

+(instancetype)sharedValue;
@end
