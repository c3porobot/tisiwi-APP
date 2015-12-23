//
//  CXNavigationBar.h
//
//  Created by zhouhai on 15/1/13.
//  Copyright (c) 2015年 zhouhai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXNavigationBar : UIView

@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, readonly) UIView *bottomLineView;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end
