//
//  TSWFinanceAndFilterViewController.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/25.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"

@interface TSWFinanceAndFilterViewController : CXNavigationBarController
@property (nonatomic, assign) NSUInteger changeRow;
@property (nonatomic, assign) NSUInteger changeCompoent;
@property (nonatomic, copy) void(^passValueBlock)(NSUInteger pickerRow, NSUInteger pickerComponent);

@end
