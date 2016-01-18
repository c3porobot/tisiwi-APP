//
//  BeforeAuditFinaceViewController.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/12.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"
#import "TSWFinanceDetailViewController.h"
@interface BeforeAuditFinaceViewController : CXNavigationBarController
@property (nonatomic ,copy) NSString *investorName; //投资人
@property (nonatomic, copy) NSString *sidValue; //当前所查看信息的id值
@property (nonatomic, copy) NSString *currentStatus;// 判断是否审核中
- (instancetype)initWithFinanceId:(NSString *)financeId;
@end
