//
//  TSWFinanceDetailViewController.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"

@interface TSWFinanceDetailViewController : CXNavigationBarController
@property (nonatomic ,copy) NSString *investorName; //投资人
- (instancetype)initWithFinanceId:(NSString *)financeId;
@end
