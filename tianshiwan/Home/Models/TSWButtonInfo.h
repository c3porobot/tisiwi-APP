//
//  TSWButtonInfo.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSWButtonInfo : NSObject

@property (nonatomic, assign) BOOL isCanClick;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, strong) UIColor *unclickColor;

@property (nonatomic, copy) NSString *title;

@end
