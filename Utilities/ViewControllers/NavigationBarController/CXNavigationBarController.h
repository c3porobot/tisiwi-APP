//
//  CXNavigationBarController.h
//
//  Created by zhouhai on 15/1/13.
//  Copyright (c) 2015年 zhouhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXNavigationBar.h"
#import "CXViewController.h"

@interface CXNavigationBarController : CXViewController<UIGestureRecognizerDelegate>

- (id)initWithNavigationBarHeight:(CGFloat)navigationBarHeight;

@property (nonatomic, readonly) CGFloat navigationBarHeight;

@property (nonatomic, readonly) CXNavigationBar *navigationBar;

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated;

- (id)archiveData:(id)dat;

- (void)back:(UIButton *)sender;

@end
