//
//  TSWLoginViewController.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"

@protocol TSWLoginViewDelegate;

@interface TSWLoginViewController : CXNavigationBarController

@property (nonatomic, weak) id<TSWLoginViewDelegate> delegate;

@end

@protocol TSWLoginViewDelegate <NSObject>

- (void)refreshData;

@end
