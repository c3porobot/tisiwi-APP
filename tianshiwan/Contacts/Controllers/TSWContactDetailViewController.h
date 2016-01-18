//
//  TSWContactDetailViewController.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/15.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"

@interface TSWContactDetailViewController : CXNavigationBarController
@property (nonatomic, copy) NSString *contectName;
@property (nonatomic, copy) NSString *contectID;
- (instancetype)initWithContactId:(NSString *)contactId;

@end
